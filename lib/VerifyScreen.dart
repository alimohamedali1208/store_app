import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/UserSeller.dart';
import 'package:store_app/loggedinhome.dart';
import 'package:store_app/sellerhome.dart';

class verifyScreen extends StatefulWidget {
  @override
  _verifyScreenState createState() => _verifyScreenState();
}

class _verifyScreenState extends State<verifyScreen> {
  final _auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  UserSeller seller = UserSeller();
  UserCustomer customer = UserCustomer();

  @override
  void initState() {
    user = _auth.currentUser;
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    UserSeller.typeList.clear();
    _auth.signOut();
    seller.firstName = "temp";
    seller.lastName = "temp";
    customer.firstName = "temp";
    customer.lastName = "temp";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
        backgroundColor: Color(0xFF731800),
      ),
      body: Column(
        children: [
          Text(
              "An email has been sent to ${user.email}, please follow the link in email to verify"),
          MaterialButton(
            onPressed: () {
              user.sendEmailVerification();
            },
            child: Text("Send Another email"),
            color: Color(0xFF731800),
          )
        ],
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = _auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      if (seller.firstName == "temp") {
        Navigator.pushNamed(context, loggedinhome.id);
      } else {
        Navigator.pushNamed(context, sellerhome.id);
      }
    }
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "An email has been sent to ${user.email}, please follow the link in the email to verify",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () {
                user.sendEmailVerification();
              },
              child: Text(
                "Send Another email",
                style: TextStyle(color: Colors.white),
              ),
              color: Color(0xFF731800),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
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

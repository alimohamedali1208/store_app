import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:store_app/Home.dart';
import 'package:store_app/UserSeller.dart';

class sellerhome extends StatefulWidget {
  static String id = 'sellerHome';
  @override
  _sellerhomeState createState() => _sellerhomeState();
}

class _sellerhomeState extends State<sellerhome> {
  final _auth = FirebaseAuth.instance;
  UserSeller seller = UserSeller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Seller Home"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(seller.firstName + ' ' + seller.lastName),
              accountEmail: Text(_auth.currentUser.email),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              decoration: new BoxDecoration(color: Colors.blueGrey[900]),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home, color: Colors.blueGrey[900]),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(Icons.person, color: Colors.blueGrey[900]),
              ),
            ),
            Divider(color: Colors.black),
            InkWell(
              child: ListTile(
                onTap: () {},
                title: Text('Settings'),
                leading: Icon(Icons.settings, color: Colors.blueGrey[900]),
              ),
            ),
            InkWell(
              child: ListTile(
                onTap: () {},
                title: Text('Help'),
                leading: Icon(Icons.help, color: Colors.blueGrey[900]),
              ),
            ),
            InkWell(
              child: ListTile(
                onTap: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, Home.id);
                  seller.lastName = 'temp';
                  seller.firstName = 'temp';
                },
                title: Text('Log out'),
                leading: Icon(Icons.logout, color: Colors.blueGrey[900]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

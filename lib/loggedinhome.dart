import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/Cart.dart';
import 'package:store_app/CustomerEditProfile.dart';
import 'package:store_app/Home.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/autoSearchCompelete.dart';
import 'package:store_app/components/CarouselImages.dart';
import 'package:store_app/components/Favorites.dart';
import 'package:store_app/components/MyOrders.dart';
import 'package:store_app/components/horizoontal_list_view.dart';

import 'components/discountProductsView.dart';
import 'components/recentProductsView.dart';

UserCustomer customer = UserCustomer();

class loggedinhome extends StatefulWidget {
  static String id = 'LHome';
  @override
  _loggedinhomeState createState() => _loggedinhomeState();
}

class _loggedinhomeState extends State<loggedinhome> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to sign out?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  _auth.signOut();
                  customer.firstName = 'temp';
                  customer.lastName = 'temp';
                  Navigator.pushNamed(context, Home.id);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carusel = CarouselImages();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: Color(0xFF731800),
          elevation: 0.0,
          title: Text(
            "ElweKalA",
            style: TextStyle(
              fontFamily: 'Zanzabar',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => autoSearchCompelete()));
                }),
            IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  return Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()));
                }),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              //header
              UserAccountsDrawerHeader(
                accountName: Text(customer.firstName + ' ' + customer.lastName),
                accountEmail: Text(_auth.currentUser.email),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.person, color: Colors.white)),
                ),
                decoration: BoxDecoration(color: Color(0xFF731800)),
              ),

              //body

              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('Home Page'),
                  leading: Icon(Icons.home, color: Colors.blueGrey[900]),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerEditProfile()));
                },
                child: ListTile(
                  title: Text('Edit Account'),
                  leading: Icon(Icons.person, color: Colors.blueGrey[900]),
                ),
              ),
              InkWell(
                onTap: () {
                  return Navigator.push(
                      context, MaterialPageRoute(builder: (context) => myOrders()));
                },
                child: ListTile(
                  title: Text('My Orders'),
                  leading:
                      Icon(Icons.shopping_basket, color: Colors.blueGrey[900]),
                ),
              ),
              InkWell(
                child: ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Favorites()));
                  },
                  title: Text('Favorites'),
                  leading: Icon(Icons.favorite, color: Colors.blueGrey[900]),
                ),
              ),
              Divider(color: Colors.black),
              /*InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Settings'),
                  leading: Icon(Icons.settings, color: Colors.blueGrey[900]),
                ),
              ),*/
              /*InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Help'),
                  leading: Icon(Icons.help, color: Colors.blueGrey[900]),
                ),
              ),*/
              InkWell(
                child: ListTile(
                  onTap: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, Home.id);
                    customer.firstName = 'temp';
                    customer.lastName = 'temp';
                  },
                  title: Text('Log out'),
                  leading: Icon(Icons.logout, color: Colors.blueGrey[900]),
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            // carusel list
            image_carusel,
            // padding
            new Padding(padding: const EdgeInsets.all(8.0)),
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            // horizontal list

            Horizontal(),
            // grid view list

            Padding(padding: const EdgeInsets.all(14)),
            Text('Recent products ',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            Container(
              child: RecenProductsView(),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Hot Deals ',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                  Image.asset("images/fire.png", width: 30.0, height: 25.0),
                ],
              ),
            ),
            Container(
              child: DiscountProductsView(),
            ),
          ],
        ),
      ),
    );
  }
}

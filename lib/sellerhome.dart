import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/Home.dart';
import 'package:store_app/UserSeller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/addCategory.dart';

import 'SellerEditProfile.dart';

class sellerhome extends StatefulWidget {
  static String id = 'sellerHome';
  @override
  _sellerhomeState createState() => _sellerhomeState();
}

class _sellerhomeState extends State<sellerhome> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  UserSeller seller = UserSeller();
  String name;
  int price;
  String picURL;

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
                  Navigator.pushNamed(context, Home.id);
                  seller.lastName = 'temp';
                  seller.firstName = 'temp';
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(seller.firstName),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[900],
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => addCategory()));
                }),
          ],
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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerEditProfile()));
                },
                child: ListTile(
                  title: Text('Edit Profile'),
                  leading: Icon(Icons.person, color: Colors.blueGrey[900]),
                ),
              ),
              InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Edit Products'),
                  leading: Icon(Icons.help, color: Colors.blueGrey[900]),
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
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collectionGroup('Products').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Text('no products available');
            else {
              final products = snapshot.data.docs;
              List<SingleProduct> productsview = [];
              for (var product in products) {
                if (_auth.currentUser.uid == product.data()['SellerID']) {
                  final productname = product.data()['Name'];
                  final productprice = product.data()['Price'].toString();
                  final productimg = product.data()['imgURL'];
                  final productview = SingleProduct(
                    productName: productname,
                    productPrice: productprice,
                    productImg: productimg,
                  );
                  productsview.add(productview);
                }
              }
              return ListView(
                children: productsview,
              );
            }
          },
        ),
      ),
    );
  }
}

class SingleProduct extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImg;

  SingleProduct({this.productName, this.productPrice, this.productImg});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //    ======= the leading image section =======
        leading: Image.network(
          productImg,
          width: 80,
          height: 80,
        ),
        title: Text(productName),
        subtitle: Column(
          children: <Widget>[
            //  ======= this for price section ======
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "\$${productPrice}",
                style: TextStyle(color: Colors.red),
              ),
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Text('Edit'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  onPressed: () {
                    //   FirebaseFirestore.instance.doc('BA').delete();
                  },
                  child: Text('Delete'),
                  color: Colors.red,
                  textColor: Colors.white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

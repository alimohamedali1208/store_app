import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/productClass.dart';

import '../UserCustomer.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

FirebaseAuth _auth = FirebaseAuth.instance;
UserCustomer customer = UserCustomer();

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(62),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: Color(0xFF731800),
          elevation: 0.0,
          title: Text("Favorites"),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 10),
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Customers')
                      .doc(_auth.currentUser.uid)
                      .collection('favorite')
                      .orderBy('ChangeFlag')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Text('no products available');
                    else {
                      final products = snapshot.data.docs;
                      List<SingleFavoritesProduct> productsview = [];
                      for (var product in products) {
                        ProductClass productInfo = ProductClass();
                        productInfo.name = product.data()['Product Name'];
                        productInfo.price = product.data()['Price'] as num;
                        productInfo.discount = product.data()['Discount'];
                        productInfo.discountPercentage =
                            product.data()['Discount percent'];
                        productInfo.newPrice = product.data()['New price'];
                        productInfo.img = product.data()['imgURL'];
                        productInfo.type = product.data()['type'];
                        productInfo.changeFlag = product.data()['ChangeFlag'];
                        productInfo.id = product.id;
                        final productview = SingleFavoritesProduct(
                          prd: productInfo,
                        );
                        productsview.add(productview);
                      }
                      return ListView(
                        children: productsview,
                      );
                    }
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SingleFavoritesProduct extends StatefulWidget {
  final ProductClass prd;

  SingleFavoritesProduct({this.prd});

  @override
  _SingleFavoritesProductState createState() => _SingleFavoritesProductState();
}

class _SingleFavoritesProductState extends State<SingleFavoritesProduct> {
  bool showSpinner = false;

  final _firestore = FirebaseFirestore.instance;

  Future addToCart() async {
    setState(() {
      showSpinner = true;
    });
    if (customer.firstName == "temp") {
      Fluttertoast.showToast(msg: "You need to sign in first");
    } else {
      print('first check if product already in cart');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('cart')
          .doc(widget.prd.id)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          print('product already in cart');
          Fluttertoast.showToast(msg: "Product already in cart");
        } else {
          print('insert product id in cart');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('cart')
              .doc(widget.prd.id)
              .set({
            'ProductID': widget.prd.id,
            'CustomerID': _auth.currentUser.uid,
            'Product Quantity': 1,
            'Product Name': widget.prd.name,
            'Price': widget.prd.price,
            'New price': widget.prd.newPrice,
            'Discount': widget.prd.discount,
            'Discount percent': widget.prd.discountPercentage,
            'type': widget.prd.type,
            'imgURL': widget.prd.img,
          });
          double price;
          if (widget.prd.discount == 'false')
            price = widget.prd.price;
          else
            price = double.parse(widget.prd.newPrice);
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .update({'Total': FieldValue.increment(price)});
          print('Product added to cart');
        }
      });
    }
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/PlaceHolder.gif',
                image: (widget.prd.img == null)
                    ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                    : widget.prd.img,
                height: 80,
                width: 120,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.prd.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                  child: (widget.prd.discount == 'false')
                      ? Text(
                          "${widget.prd.price} EGP",
                          style: TextStyle(color: Colors.red),
                        )
                      : Row(
                          children: [
                            Text(
                              "${widget.prd.price} EGP",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.prd.newPrice} EGP",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                ),
                Container(
                  child: OutlineButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      addToCart();
                    },
                    borderSide: BorderSide(color: Colors.black),
                    highlightedBorderColor: Colors.grey,
                    child: Text("Move To Cart"),
                  ),
                )
              ],
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  //todo some delete action
                },
                icon: Icon(Icons.delete)),
          ],
        )
      ],
    );
  }
}

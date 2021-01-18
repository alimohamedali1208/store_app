import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ProductDetails.dart';

class SellerProducts extends StatefulWidget {
  @override
  _SellerProducts createState() => _SellerProducts();
}

class _SellerProducts extends State<SellerProducts> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String name;
  int price;

  @override
  void initState() {
    getProducts();
  }

  void getProducts() async {
    final DBRow = await _firestore.collection('SellerProduct').get();
    for (var usern in DBRow.docs) {
      name = usern.get('name');
      price = usern.get('price');
    }
    print(name + '$price');
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 1,
        shrinkWrap: true,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Single_product(
            prod_name: name,
            prod_price: price,
          );
        });
  }
}

class Single_product extends StatelessWidget {
  final prod_name;
  final prod_price;

  const Single_product({this.prod_name, this.prod_price});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: Hero(
        tag: prod_name,
        child: Material(
          child: InkWell(
            onTap: () {
              return Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) => new ProductDetails(
                    // passing the values via constructor
                    product_detail_name: prod_name,
                    product_detail_new_price: prod_price,
                  ),
                ),
              );
            },
            child: GridTile(
              child: Text('Place holder'),
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    prod_name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    "\$$prod_price",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

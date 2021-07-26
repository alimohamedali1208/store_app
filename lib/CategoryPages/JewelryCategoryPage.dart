import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/ProductDetails.dart';
import 'package:store_app/SearchPages/JewelryCatSearch.dart';
import 'package:store_app/SearchPages/LaptopCatSearch.dart';
import 'package:store_app/login.dart';
import 'package:store_app/productClass.dart';

class jewelryCategoryPage extends StatefulWidget {
  @override
  _jewelryCategoryPageState createState() => _jewelryCategoryPageState();
}

class _jewelryCategoryPageState extends State<jewelryCategoryPage> {
  final database = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60),
        child: AppBar(
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: Color(0xFF731800),
          title: Text(
            "Jewelry",
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => jewelryCatSearch()));
                }),
          ],
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
                      .collectionGroup('Products')
                      .where('type', isEqualTo: "Jewelry")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        final products = snapshot.data.docs;
                        var productview;
                        List<SingleProduct> productsview = [];
                        for (var product in products) {
                          ProductClass productInfo = ProductClass();
                          productInfo.name = product.data()['Product Name'];
                          productInfo.price = product.data()['Price'];
                          productInfo.img = product.data()['imgURL'];
                          productInfo.type = product.data()['type'];
                          productInfo.description =
                              product.data()['Description'];
                          productInfo.metalType = product.data()['Metal Type'];
                          productInfo.targetGroup =
                              product.data()['Target Group'];
                          productInfo.ClothSize = product.data()['Size'];
                          productInfo.brand = product.data()['Brand Name'];
                          productInfo.quantity = product.data()['Quantity'];
                          productInfo.sellerEmail =
                              product.data()['Seller Email'];
                          productInfo.discount = product.data()['Discount'];
                          productInfo.discountPercentage =
                              product.data()['Discount percent'];
                          productInfo.newPrice = product.data()['New price'];
                          productInfo.rate1star = product.data()['1 star rate'];
                          productInfo.rate2star = product.data()['2 star rate'];
                          productInfo.rate3star = product.data()['3 star rate'];
                          productInfo.rate4star = product.data()['4 star rate'];
                          productInfo.rate5star = product.data()['5 star rate'];
                          productInfo.rate = product.data()['Rating'];
                          productInfo.id = product.id;
                          productview = SingleProduct(
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

class SingleProduct extends StatefulWidget {
  ProductClass prd;

  SingleProduct({this.prd});

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isPressed = false;
  bool cartIsPressed = false;

  Future addToCart() async {
    if (customer.firstName == "temp") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
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
            'Product Quantity': widget.prd.quantity,
            'Ordered Quantity': '1',
            'Product Name': widget.prd.name,
            'Price': widget.prd.price,
            'New price': widget.prd.newPrice,
            'Discount': widget.prd.discount,
            'Discount percent': widget.prd.discountPercentage,
            'type': widget.prd.type,
            'ChangeFlag': 'false',
            'imgURL': widget.prd.img
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
          setState(() {
            cartIsPressed = true;
          });
          removeFromFav();
          print('Product added to cart');
        }
      });
    }
  }

  Future addToFav() async {
    if (customer.firstName == "temp") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
      Fluttertoast.showToast(msg: "You need to sign in first");
    } else {
      print('first check if product already in fav');

      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('favorite')
          .doc(widget.prd.id)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          print('product already in fav');
          removeFromFav();
          setState(() {
            isPressed = false;
          });
        } else {
          print('insert product id in fav');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('favorite')
              .doc(widget.prd.id)
              .set({
            'ProductID': widget.prd.id,
            'CustomerID': _auth.currentUser.uid,
            'Product Name': widget.prd.name,
            'Product Quantity': 1,
            'Price': widget.prd.price,
            'New price': widget.prd.newPrice,
            'Discount': widget.prd.discount,
            'Discount percent': widget.prd.discountPercentage,
            'type': widget.prd.type,
            'ChangeFlag': 'false',
            'imgURL': widget.prd.img
          });
          setState(() {
            isPressed = true;
          });
        }
      });
    }
  }

  Future removeFromFav() async {
    if (customer.firstName == "temp") {
      Fluttertoast.showToast(msg: "You need to sign in first");
    } else {
      print('first check if product already in fav');
      await _firestore
          .collection('Customers')
          .doc(_auth.currentUser.uid)
          .collection('favorite')
          .doc(widget.prd.id)
          .get()
          .then((DocumentSnapshot snapshot) async {
        if (!snapshot.exists) {
          print('product not in favorites');
        } else {
          print('remove product from fav');
          await _firestore
              .collection('Customers')
              .doc(_auth.currentUser.uid)
              .collection('favorite')
              .doc(widget.prd.id)
              .delete();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) => ProductDetails(
                // passing the values via constructor
                prd: widget.prd,
              ),
            ),
          );
        },
        child: ListTile(
          //    ======= the leading image section =======
          leading: FadeInImage.assetNetwork(
            placeholder: 'images/PlaceHolder.gif',
            image: (widget.prd.img == null)
                ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
                : widget.prd.img,
            height: 80,
            width: 80,
          ),
          title: Text(widget.prd.name),
          subtitle: Column(
            children: <Widget>[
              //  ======= this for price section ======
              Container(
                alignment: Alignment.topLeft,
                child: (widget.prd.discount == 'false')
                    ? Text(
                        "${widget.prd.price} EGP",
                        style: TextStyle(color: Colors.red),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${widget.prd.price}",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${widget.prd.newPrice} EGP",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RatingBarIndicator(
                    rating: double.parse(widget.prd.rate),
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    '${widget.prd.rate}',
                    style: TextStyle(height: 1.5),
                  ),
                  Spacer(),
                  Row(
                    children: (widget.prd.quantity == '0')
                        ? [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.red[600],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "Out of stock",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ]
                        : [
                            IconButton(
                                icon: (isPressed)
                                    ? Icon(Icons.favorite)
                                    : Icon(Icons.favorite_outline),
                                tooltip: 'Add to favorites',
                                color: Colors.red,
                                onPressed: () {
                                  addToFav();
                                }),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              icon: (cartIsPressed)
                                  ? Icon(Icons.download_done_rounded)
                                  : Icon(Icons.add_shopping_cart_outlined),
                              tooltip: 'Add to cart',
                              color: Colors.black,
                              onPressed:
                                  cartIsPressed ? null : () => addToCart(),
                            ),
                          ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

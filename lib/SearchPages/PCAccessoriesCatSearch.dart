import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/ProductDetails.dart';

import '../productClass.dart';

class pcAccessoriesCatSearch extends StatefulWidget {
  @override
  _pcAccessoriesCatSearchState createState() => _pcAccessoriesCatSearchState();
}

class _pcAccessoriesCatSearchState extends State<pcAccessoriesCatSearch> {
  final database = FirebaseFirestore.instance;
  String searchString = '';
  int ddStorage, ddRatings;
  String ddSearchBrand, ddSearchType = "StorageDevices";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 110),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                SizedBox(height: 20),
                TextField(
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.none,
                  autofocus: false,
                  style: TextStyle(fontSize: 16),
                  cursorColor: Colors.blue[900],
                  onChanged: (val) {
                    setState(() {
                      searchString = val.toLowerCase().trim();
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white70,
                    prefixIcon: IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.arrow_back),
                      iconSize: 20.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    contentPadding: EdgeInsets.only(left: 25.0),
                    hintText: 'Search for PC Accessories',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton<String>(
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem<String>(
                              child: Text('Storage Devices'),
                              value: 'StorageDevices',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Printers'),
                              value: 'Printers',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Other'),
                              value: 'OtherPC',
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              ddSearchBrand = null;
                              ddSearchType = value;
                            });
                          },
                          value: ddSearchType,
                        ),
                      ),
                      Row(
                        children: (ddSearchType == "StorageDevices")
                            ? [
                                Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: DropdownButton<String>(
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600),
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text('Western Digital'),
                                        value: 'Western Digital',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Sandisk'),
                                        value: 'Sandisk',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Seagate'),
                                        value: 'Seagate',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Other'),
                                        value: 'Other',
                                      ),
                                    ],
                                    onChanged: (String value) {
                                      setState(() {
                                        if (value == 'Other') value = null;
                                        ddSearchBrand = value;
                                      });
                                    },
                                    hint: Text('Choose Brand'),
                                    value: ddSearchBrand,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: DropdownButton<int>(
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600),
                                    items: [
                                      DropdownMenuItem<int>(
                                        child: Text('>1 TB'),
                                        value: 1,
                                      ),
                                      DropdownMenuItem<int>(
                                        child: Text('>2 TB'),
                                        value: 2,
                                      ),
                                    ],
                                    onChanged: (int value) {
                                      setState(() {
                                        ddStorage = value;
                                      });
                                    },
                                    hint: Text('Choose Storage'),
                                    value: ddStorage,
                                  ),
                                ),
                              ]
                            : [
                                Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: DropdownButton<String>(
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600),
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text('Samsung'),
                                        value: 'Samsung',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Sony'),
                                        value: 'Sony',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('HP'),
                                        value: 'HP',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Other'),
                                        value: 'Other',
                                      ),
                                    ],
                                    onChanged: (String value) {
                                      setState(() {
                                        if (value == 'Other') value = null;
                                        ddSearchBrand = value;
                                      });
                                    },
                                    hint: Text('Choose Brand'),
                                    value: ddSearchBrand,
                                  ),
                                ),
                                Row(
                                  children: (ddSearchType == "Printers")
                                      ? [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 5, right: 5),
                                            padding: EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white70,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: DropdownButton<String>(
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w600),
                                              items: [
                                                DropdownMenuItem<String>(
                                                  child: Text('Samsung'),
                                                  value: 'Samsung',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('Sony'),
                                                  value: 'Sony',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('HP'),
                                                  value: 'HP',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('Other'),
                                                  value: 'Other',
                                                ),
                                              ],
                                              onChanged: (String value) {
                                                setState(() {
                                                  if (value == 'Other')
                                                    value = null;
                                                  ddSearchBrand = value;
                                                });
                                              },
                                              hint: Text('Choose Paper Size'),
                                              value: ddSearchBrand,
                                            ),
                                          ),
                                        ]
                                      : [],
                                ),
                              ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton<int>(
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem<int>(
                              child: Text('>1 Star'),
                              value: 1,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('>2 Stars'),
                              value: 2,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('>3 Stars'),
                              value: 3,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('>4 Stars'),
                              value: 4,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('5 Stars'),
                              value: 5,
                            ),
                            DropdownMenuItem<int>(
                              child: Text('No Reviews'),
                              value: 0,
                            ),
                          ],
                          onChanged: (int value) {
                            setState(() {
                              if (value == 0) value = null;
                              ddRatings = value;
                            });
                          },
                          hint: Text('Choose Rating'),
                          value: ddRatings,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
          backgroundColor: Color(0xFF731800),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('Products')
                      .where('type', isEqualTo: ddSearchType)
                      .where('searchIndex', arrayContains: searchString)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        final products = snapshot.data.docs;
                        List<SingleProduct> productsview = [];
                        for (var product in products) {
                          ProductClass productInfo = ProductClass();
                          productInfo.storage = product.data()['Storage'];
                          productInfo.rate = product.data()['Rating'];
                          if (ddStorage == null ||
                              productInfo.storage >= ddStorage) {
                            if (ddRatings == null ||
                                double.parse(productInfo.rate) >= ddRatings) {
                              productInfo.name = product.data()['Product Name'];
                              productInfo.brand = product.data()['Brand Name'];
                              productInfo.quantity = product.data()['Quantity'];
                              productInfo.description =
                                  product.data()['Description'];
                              productInfo.price = product.data()['Price'];
                              productInfo.newPrice =
                                  product.data()['New price'];
                              productInfo.discount = product.data()['Discount'];
                              productInfo.discountPercentage =
                                  product.data()['Discount percent'];
                              productInfo.rate1star =
                                  product.data()['1 star rate'];
                              productInfo.rate2star =
                                  product.data()['2 star rate'];
                              productInfo.rate3star =
                                  product.data()['3 star rate'];
                              productInfo.rate4star =
                                  product.data()['4 star rate'];
                              productInfo.rate5star =
                                  product.data()['5 star rate'];
                              productInfo.img = product.data()['imgURL'];
                              productInfo.type = product.data()['type'];
                              productInfo.sellerEmail =
                                  product.data()['Seller Email'];
                              productInfo.id = product.id;
                              final productview = SingleProduct(
                                prd: productInfo,
                              );
                              productsview.add(productview);
                            }
                          }
                        }
                        return ListView(children: productsview);
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
  final ProductClass prd;

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
          print('Product added to cart');
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
                  IconButton(
                      icon: (isPressed)
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_outline),
                      tooltip: 'Add to favorites',
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          if (isPressed)
                            isPressed = false;
                          else
                            isPressed = true;
                        });
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
                    onPressed: cartIsPressed ? null : () => addToCart(),
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

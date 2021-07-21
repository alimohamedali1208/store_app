import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/ProductDetails.dart';
import 'package:store_app/login.dart';

import '../productClass.dart';

class homeAppliancesCatSearch extends StatefulWidget {
  @override
  _homeAppliancesCatSearchState createState() =>
      _homeAppliancesCatSearchState();
}

class _homeAppliancesCatSearchState extends State<homeAppliancesCatSearch> {
  final database = FirebaseFirestore.instance;
  String searchString = '';
  int ddRatings;
  String ddSearchBrand,
      ddSearchType = 'TV',
      ddTvType,
      ddHorsePower,
      ddMaterial,
      ddColor,
      ddScreenRes,
      ddScreenSize;

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
                    hintText: 'Search for Home Appliances',
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
                              child: Text('TV'),
                              value: 'TV',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Fridges'),
                              value: 'Fridges',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Air Conditioners'),
                              value: 'AirConditioner',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Other'),
                              value: 'OtherHome',
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              ddSearchBrand = null;
                              ddColor = null;
                              ddMaterial =null;
                              ddHorsePower = null;
                              ddTvType = null;
                              ddScreenRes = null;
                              ddScreenSize = null;
                              ddSearchType = value;
                            });
                          },
                          hint: Text('Choose Home Appliance'),
                          value: ddSearchType,
                        ),
                      ),
                      Row(
                        children: (ddSearchType == "OtherHome")
                            ? []
                            : [
                                Row(
                                  children: (ddSearchType == "TV")
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
                                                  child: Text('Sony'),
                                                  value: 'Sony',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('LG'),
                                                  value: 'LG',
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
                                              hint: Text('Choose Brand'),
                                              value: ddSearchBrand,
                                            ),
                                          ),
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
                                                  child: Text('30 inches'),
                                                  value: '30',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('40 inches'),
                                                  value: '40',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('50 inches'),
                                                  value: '50',
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
                                                  ddScreenSize = value;
                                                });
                                              },
                                              hint: Text('Choose Screen Size'),
                                              value: ddScreenSize,
                                            ),
                                          ),
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
                                                  child: Text('HD'),
                                                  value: 'HD',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('Full HD'),
                                                  value: 'Full HD',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('2K'),
                                                  value: '2K',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('4K'),
                                                  value: '4K',
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
                                                  ddScreenRes = value;
                                                });
                                              },
                                              hint: Text(
                                                  'Choose Screen resolution'),
                                              value: ddScreenRes,
                                            ),
                                          ),
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
                                                  child: Text('Smart TV'),
                                                  value: 'Smart TV',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('Standard TV'),
                                                  value: 'Standard TV',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('Android TV'),
                                                  value: 'Android TV',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('3D TV'),
                                                  value: '3D TV',
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
                                                  ddTvType = value;
                                                });
                                              },
                                              hint: Text(
                                                  'Choose TV type'),
                                              value: ddTvType,
                                            ),
                                          ),
                                        ]
                                      : [
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white70,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: DropdownButton<String>(
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  items: [
                                                    DropdownMenuItem<String>(
                                                      child: Text('Carrier'),
                                                      value: 'Carrier',
                                                    ),
                                                    DropdownMenuItem<String>(
                                                      child: Text('Unionair'),
                                                      value: 'Unionair',
                                                    ),
                                                    DropdownMenuItem<String>(
                                                      child: Text('Samsung'),
                                                      value: 'Samsung',
                                                    ),
                                                    DropdownMenuItem<String>(
                                                      child: Text('Toshiba'),
                                                      value: 'Toshiba',
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
                                                  hint: Text('Choose Brand'),
                                                  value: ddSearchBrand,
                                                ),
                                              ),
                                              Row(
                                                children: (ddSearchType ==
                                                        'Fridges')
                                                    ? [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5,
                                                                  right: 5),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white70,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: DropdownButton<
                                                              String>(
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    'Metal'),
                                                                value: 'Metal',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    'Glass'),
                                                                value: 'Glass',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    'Stainless steel'),
                                                                value:
                                                                    'Stainless steel',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    'Glass'),
                                                                value: 'Glass',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    'Other'),
                                                                value: 'Other',
                                                              ),
                                                            ],
                                                            onChanged:
                                                                (String value) {
                                                              setState(() {
                                                                if (value ==
                                                                    'Other')
                                                                  value = null;
                                                                ddMaterial =
                                                                    value;
                                                              });
                                                            },
                                                            hint: Text(
                                                                'Choose Material'),
                                                            value: ddMaterial,
                                                          ),
                                                        ),
                                                      ]
                                                    : [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5,
                                                                  right: 5),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white70,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: DropdownButton<
                                                              String>(
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            items: [
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    '1.50'),
                                                                value: '1.50',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    '2.00'),
                                                                value: '2.00',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    '2.50'),
                                                                value: '2.50',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    '3.00'),
                                                                value: '3.00',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    '3.50'),
                                                                value: '3.50',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    '4.00'),
                                                                value: '4.00',
                                                              ),
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child: Text(
                                                                    'Other'),
                                                                value: 'Other',
                                                              ),
                                                            ],
                                                            onChanged:
                                                                (String value) {
                                                              setState(() {
                                                                if (value ==
                                                                    'Other')
                                                                  value = null;
                                                                ddHorsePower =
                                                                    value;
                                                              });
                                                            },
                                                            hint: Text(
                                                                'Choose Horse Power'),
                                                            value: ddHorsePower,
                                                          ),
                                                        ),
                                                      ],
                                              )
                                            ],
                                          ),
                                        ],
                                ),
                              ],
                      ),
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
                              child: Text('Black'),
                              value: 'black',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('White'),
                              value: 'white',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Red'),
                              value: 'red',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Silver'),
                              value: 'silver',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Other'),
                              value: 'Other',
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              if (value == 'Other') value = null;
                              ddColor = value;
                            });
                          },
                          hint: Text('Choose Color'),
                          value: ddColor,
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
                      ),
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
                          productInfo.rate = product.data()['Rating'];
                          productInfo.brand = product.data()['Brand Name'];
                          productInfo.tvType = product.data()['Category Type'];
                          productInfo.screenSize = product.data()['Screen Size'];
                          productInfo.screenRes = product.data()['Screen Resolution'];
                          productInfo.material = product.data()['Material'];
                          productInfo.horsePower = product.data()['Horse Power'];
                          productInfo.color = product.data()['Color'];
                          if (ddColor == null || productInfo.color == ddColor) {
                            if (ddHorsePower == null || productInfo.horsePower == ddHorsePower) {
                              if (ddMaterial == null || productInfo.material == ddMaterial) {
                                if (ddScreenRes == null || productInfo.screenRes == ddScreenRes) {
                                  if (ddScreenSize == null || productInfo.screenSize == ddScreenSize) {
                                    if (ddTvType == null || productInfo.tvType == ddTvType) {
                                      if (ddSearchBrand == null ||productInfo.brand == ddSearchBrand) {
                                        if (ddRatings == null ||double.parse(productInfo.rate) >= ddRatings) {
                                          productInfo.name = product.data()['Product Name'];
                                          productInfo.quantity = product.data()['Quantity'];
                                          productInfo.description =product.data()['Description'];
                                          productInfo.weight = product.data()['Weight'];
                                          productInfo.width = product.data()['Width'];
                                          productInfo.depth = product.data()['Depth'];
                                          productInfo.height = product.data()['Height'];
                                          productInfo.screenType = product.data()['Screen Type'];
                                          productInfo.conditionerType = product.data()['Conditioner Type'];
                                          productInfo.price = product.data()['Price'];
                                          productInfo.newPrice = product.data()['New price'];
                                          productInfo.discount = product.data()['Discount'];
                                          productInfo.discountPercentage =product.data()['Discount percent'];
                                          productInfo.rate1star = product.data()['1 star rate'];
                                          productInfo.rate2star = product.data()['2 star rate'];
                                          productInfo.rate3star = product.data()['3 star rate'];
                                          productInfo.rate4star = product.data()['4 star rate'];
                                          productInfo.rate5star = product.data()['5 star rate'];
                                          productInfo.img = product.data()['imgURL'];
                                          productInfo.type = product.data()['type'];
                                          productInfo.sellerEmail = product.data()['Seller Email'];
                                          productInfo.id = product.id;
                                          final productview = SingleProduct(
                                            prd: productInfo,
                                          );
                                          productsview.add(productview);
                                        }
                                      }
                                    }
                                  }
                                }
                              }
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

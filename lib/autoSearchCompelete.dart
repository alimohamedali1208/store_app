import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/MobileCatSearch.dart';
import 'package:store_app/ProductDetails.dart';
import 'package:store_app/SearchPages/CameraCatSearch.dart';
import 'package:store_app/SearchPages/ElectronicsCatSearch.dart';
import 'package:store_app/SearchPages/FashionCatSearch.dart';
import 'package:store_app/SearchPages/HomeAppliancesCatSearch.dart';
import 'package:store_app/SearchPages/JewelryCatSearch.dart';
import 'package:store_app/SearchPages/LaptopCatSearch.dart';
import 'package:store_app/SearchPages/PCAccessoriesCatSearch.dart';
import 'package:store_app/login.dart';
import 'package:store_app/productClass.dart';

class autoSearchCompelete extends StatefulWidget {
  @override
  _autoSearchCompeleteState createState() => _autoSearchCompeleteState();
}

class _autoSearchCompeleteState extends State<autoSearchCompelete> {
  final database = FirebaseFirestore.instance;
  String searchString = '';
  String ddSearchCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 110),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    hintText: 'Search By Name',
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 30,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20)),
                  child: DropdownButton<String>(
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                    items: [
                      DropdownMenuItem<String>(
                        child: Text('Laptops'),
                        value: 'laptops',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Mobiles'),
                        value: 'mobiles',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Home Appliances'),
                        value: 'home',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Electronics'),
                        value: 'elec',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('PC Accessories'),
                        value: 'pc',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Fashion'),
                        value: 'fashion',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Jewelry'),
                        value: 'jewelry',
                      ),
                      DropdownMenuItem<String>(
                        child: Text('Cameras'),
                        value: 'cam',
                      ),
                    ],
                    onChanged: (String value) {
                      setState(() {
                        if (value == 'laptops') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => laptopCatSearch()));
                        } else if (value == 'mobiles') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => mobileCatSearch()));
                        } else if (value == 'home') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => homeAppliancesCatSearch()));
                        }else if (value == 'elec') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => electronicsCatSearch()));
                        }else if (value == 'pc') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => pcAccessoriesCatSearch()));
                        }else if (value == 'fashion') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => fashionCatSearch()));
                        }else if (value == 'jewelry') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => jewelryCatSearch()));
                        }else if (value == 'cam') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => cameraCatSearch()));
                        }
                      });
                    },
                    hint: Text('Choose Category'),
                    value: ddSearchCategory,
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
                SizedBox(height: 10),
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('Products')
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
                        var productview;
                        List<SingleProduct> productsview = [];
                        for (var product in products) {
                          ProductClass productInfo = ProductClass();
                          productInfo.name = product.data()['Product Name'];
                          productInfo.price = product.data()['Price'] as num;
                          productInfo.img = product.data()['imgURL'];
                          productInfo.type = product.data()['type'];
                          productInfo.description = product.data()['Description'];
                          productInfo.color = product.data()['Color'];
                          productInfo.brand = product.data()['Brand Name'];
                          productInfo.quantity = product.data()['Quantity'];
                          productInfo.sellerEmail = product.data()['Seller Email'];
                          productInfo.discount = product.data()['Discount'];
                          productInfo.discountPercentage = product.data()['Discount percent'];
                          productInfo.newPrice = product.data()['New price'];
                          productInfo.rate1star = product.data()['1 star rate'];
                          productInfo.rate2star = product.data()['2 star rate'];
                          productInfo.rate3star = product.data()['3 star rate'];
                          productInfo.rate4star = product.data()['4 star rate'];
                          productInfo.rate5star = product.data()['5 star rate'];
                          productInfo.rate = product.data()['Rating'];
                          productInfo.id = product.id;
                          //now stuff that's specific for every product type
                          if (productInfo.type == 'Mobiles') {
                            productInfo.storage = product.data()['Storage'];
                            productInfo.storageUnit =
                                product.data()['Storage Unit'];
                            productInfo.screenSize =
                                product.data()['Screen Size'];
                            productInfo.battery = product.data()['Battery'];
                            productInfo.memory = product.data()['Memory'];
                            productInfo.memoryUnit =
                                product.data()['Memory Unit'];
                            productInfo.camera = product.data()['Camera'];
                            productInfo.os = product.data()['OS'];
                          } else if (productInfo.type == 'Laptops') {
                            productInfo.storage = product.data()['Storage'];
                            productInfo.storageUnit =
                                product.data()['Storage Unit'];
                            productInfo.screenSize =
                                product.data()['Screen Size'];
                            productInfo.battery = product.data()['Battery'];
                            productInfo.memory = product.data()['Memory'];
                            productInfo.cpu = product.data()['CPU'];
                            productInfo.gpu = product.data()['GPU'];
                            productInfo.os = product.data()['OS'];
                          } else if (productInfo.type == 'Cameras') {
                            productInfo.megapixel =
                                product.data()['Mega Pixel'];
                            productInfo.screenType =
                                product.data()['Screen Type'];
                            productInfo.opticalzoom =
                                product.data()['Optical Zoom'];
                            productInfo.cameratype =
                                product.data()['Camera Type'];
                            productInfo.screenSize =
                                product.data()['Screen Size'];
                          } else if (productInfo.type == 'CameraAccessories' ||
                              productInfo.type == 'OtherPC') {
                            productInfo.accessoryType =
                                product.data()['AccessoryType'];
                          } else if (productInfo.type == 'Fridges') {
                            productInfo.weight = product.data()['Weight'];
                            productInfo.width = product.data()['Width'];
                            productInfo.depth = product.data()['Depth'];
                            productInfo.height = product.data()['Height'];
                            productInfo.material = product.data()['Material'];
                          } else if (productInfo.type == 'AirConditioner') {
                            productInfo.weight = product.data()['Weight'];
                            productInfo.width = product.data()['Width'];
                            productInfo.depth = product.data()['Depth'];
                            productInfo.conditionerType =
                                product.data()['Conditioner Type'];
                            productInfo.horsePower =
                                product.data()['Horse Power'];
                          } else if (productInfo.type == 'TV') {
                            productInfo.weight = product.data()['Weight'];
                            productInfo.width = product.data()['Width'];
                            productInfo.depth = product.data()['Depth'];
                            productInfo.screenSize =
                                product.data()['Screen Size'];
                            productInfo.screenType =
                                product.data()['Screen Type'];
                            productInfo.screenRes =
                                product.data()['Screen Resolution'];
                            productInfo.tvType =
                                product.data()['Category Type'];
                          } else if (productInfo.type == 'OtherHome') {
                            productInfo.weight = product.data()['Weight'];
                            productInfo.width = product.data()['Width'];
                            productInfo.depth = product.data()['Depth'];
                            productInfo.height = product.data()['Height'];
                          } else if (productInfo.type == 'Jewelry') {
                            productInfo.metalType =
                                product.data()['Metal Type'];
                            productInfo.targetGroup =
                                product.data()['Target Group'];
                          } else if (productInfo.type == 'Projectors') {
                            productInfo.projectorType =
                                product.data()['Projector Type'];
                          } else if (productInfo.type == 'Printers') {
                            productInfo.printerType =
                                product.data()['Printer Type'];
                            productInfo.paperSize =
                                product.data()['Paper Type'];
                          } else if (productInfo.type == 'StorageDevices') {
                            productInfo.storageType =
                                product.data()['Storage Type'];
                            productInfo.storageUnit =
                                product.data()['Capacity'];
                          } else if (productInfo.type == 'Fashion') {
                            productInfo.clothType =
                                product.data()['Clothing Type'];
                            productInfo.ClothSize = product.data()['Size'];
                          }
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
            price = widget.prd.price.toDouble();
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
          removeFromFav();
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
          setState(() {
            isPressed = false;
          });
          removeFromFav();
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
            'Product Quantity': widget.prd.quantity,
            'Ordered Quantity': '1',
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

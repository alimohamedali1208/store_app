import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/EditPages/editAirConditioner.dart';
import 'package:store_app/EditPages/editCameraAccessory.dart';
import 'package:store_app/EditPages/editCameras.dart';
import 'package:store_app/EditPages/editElectronics.dart';
import 'package:store_app/EditPages/editFashion.dart';
import 'package:store_app/EditPages/editFridge.dart';
import 'package:store_app/EditPages/editHomeAppliances.dart';
import 'package:store_app/EditPages/editJewelary.dart';
import 'package:store_app/EditPages/editLaptop.dart';
import 'package:store_app/EditPages/editMobile.dart';
import 'package:store_app/EditPages/editPCAccessories.dart';
import 'package:store_app/EditPages/editPrinter.dart';
import 'package:store_app/EditPages/editProjector.dart';
import 'package:store_app/EditPages/editStorageDevice.dart';
import 'package:store_app/EditPages/editTV.dart';
import 'package:store_app/Home.dart';
import 'package:store_app/UserSeller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/addCategory.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'SellerEditProfile.dart';

class sellerhome extends StatefulWidget {
  static String id = 'sellerHome';
  @override
  _sellerhomeState createState() => _sellerhomeState();
}

class _sellerhomeState extends State<sellerhome> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UserSeller seller = UserSeller();
  //String name;
  //int price;
  //String picURL;

  //Showing snackbar
  void _showSnackbar(String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      // duration: const Duration(seconds: 10),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to sign out?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
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
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            title: Column(
              children: [
                SizedBox(height: 30),
                Text(seller.firstName),
              ],
            ),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            backgroundColor: Color(0xFF731800),
            actions: <Widget>[],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(seller.firstName + ' ' + seller.lastName),
                accountEmail: Text(_auth.currentUser.email),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(color: Color(0xFF731800)),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text('Home Page'),
                  leading: Icon(Icons.home, color: Colors.black),
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
                  leading: Icon(Icons.person, color: Colors.black),
                ),
              ),
              InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Edit Products'),
                  leading: Icon(Icons.help, color: Colors.black),
                ),
              ),
              Divider(color: Colors.black),
              InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Settings'),
                  leading: Icon(Icons.settings, color: Colors.black),
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
                  leading: Icon(Icons.logout, color: Colors.black),
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
                  final productname = product.data()['Product Name'];
                  final productprice = product.data()['Price'];
                  final productdiscount = product.data()['Discount'];
                  final productdiscountpercent =
                      product.data()['Discount percent'];
                  final productnewprice = product.data()['New price'];
                  final productimg = product.data()['imgURL'];
                  final producttype = product.data()['type'];
                  final productrate = product.data()['Rating'];
                  final productid = product.id;
                  final productview = SingleProduct(
                    productName: productname,
                    productPrice: productprice,
                    productNewPrice: productnewprice,
                    productDiscountFlag: productdiscount,
                    productDiscountPercent: productdiscountpercent,
                    productImg: productimg,
                    productType: producttype,
                    productID: productid,
                    productRating: productrate,
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
        bottomNavigationBar: ConvexButton.fab(
            icon: Icons.add,
            color: Colors.white,
            backgroundColor: Color(0xFF731800),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => addCategory()));
            }),
      ),
    );
  }
}

class SingleProduct extends StatefulWidget {
  final String productName;
  final double productPrice;
  final String productNewPrice;
  final String productDiscountFlag;
  final String productDiscountPercent;
  final String productImg;
  final String productType;
  final String productID;
  final String productRating;

  SingleProduct(
      {this.productName,
      this.productPrice,
      this.productNewPrice,
      this.productDiscountFlag,
      this.productDiscountPercent,
      this.productImg,
      this.productID,
      this.productType,
      this.productRating});

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  final _formKey = GlobalKey<FormState>();
  double oldPrice;
  File _image;
  double offer;
  Future getImage() async {
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //    ======= the leading image section =======
        leading: FadeInImage.assetNetwork(
          placeholder: 'images/PlaceHolder.gif',
          image: (widget.productImg == null)
              ? "https://firebasestorage.googleapis.com/v0/b/store-cc25c.appspot.com/o/uploads%2FPlaceHolder.gif?alt=media&token=89558fba-e8b6-4b99-bcb7-67bf1412a83a"
              : widget.productImg,
          height: 80,
          width: 80,
        ),
        title: Text(widget.productName),
        subtitle: Column(
          children: <Widget>[
            //  ======= this for price section ======
            Container(
              alignment: Alignment.topLeft,
              child: (widget.productDiscountFlag == 'false')
                  ? Text(
                      "${widget.productPrice} EGP",
                      style: TextStyle(color: Colors.red),
                    )
                  : Row(
                      children: [
                        Text(
                          "${widget.productPrice} EGP",
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.productNewPrice} EGP",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    // ignore: unrelated_type_equality_checks
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Choose an Option"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    if (widget.productType == 'Laptops') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editLaptops()));
                                    } else if (widget.productType ==
                                        'AirConditioner') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editAirConditioner()));
                                    } else if (widget.productType ==
                                        'Cameras') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editCameras()));
                                    } else if (widget.productType ==
                                        'CameraAccessories') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editCameraAccessory()));
                                    } else if (widget.productType ==
                                        'CameraAccessories') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editCameraAccessory()));
                                    } else if (widget.productType ==
                                        'OtherElectronics') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editElectronics()));
                                    } else if (widget.productType ==
                                        'Fashion') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editFashion()));
                                    } else if (widget.productType ==
                                        'Fridges') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editFridge()));
                                    } else if (widget.productType ==
                                        'Jewelry') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editJewelary()));
                                    } else if (widget.productType ==
                                        'Mobiles') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editMobile()));
                                    } else if (widget.productType ==
                                        'OtherHome') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editHomeAppliances()));
                                    } else if (widget.productType ==
                                        'OtherPC') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editPCAccessories()));
                                    } else if (widget.productType ==
                                        'Printers') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editPrinter()));
                                    } else if (widget.productType ==
                                        'Projectors') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editProjector()));
                                    } else if (widget.productType ==
                                        'StorageDevice') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editStorageDevice()));
                                    } else if (widget.productType == 'TV') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => editTV()));
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Color(0xFF731800),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Edit This Product",
                                          style: TextStyle(
                                            color: Color(0xFF731800),
                                          )),
                                    ],
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    await getImage();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.filter,
                                        color: Color(0xFF731800),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Edit Product Picture",
                                          style: TextStyle(
                                            color: Color(0xFF731800),
                                          )),
                                    ],
                                  )),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Offer"),
                                        content: Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            enableInteractiveSelection: false,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: "Add offer percentage",
                                            ),
                                            onSaved: (value) {
                                              if (value == null)
                                                print('nope');
                                              else
                                                offer =
                                                    double.parse(value.trim());
                                            },
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              "Go back",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () async {
                                              _formKey.currentState.save();
                                              Navigator.of(context).pop();

                                              if (offer == 0 || offer == null) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Discount has been removed",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    backgroundColor:
                                                        Colors.black54,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                double newPrice = widget
                                                        .productPrice -
                                                    double.parse(
                                                        widget.productNewPrice);
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'ProductsCollection')
                                                    .doc(widget.productType)
                                                    .collection('Products')
                                                    .doc(widget.productID)
                                                    .update({
                                                  'Discount': 'false',
                                                  'Discount percent': '0',
                                                  'New price': '0'
                                                });
                                                await FirebaseFirestore.instance
                                                    .collectionGroup('cart')
                                                    .where('ProductID',
                                                        isEqualTo:
                                                            widget.productID)
                                                    .get()
                                                    .then((value) {
                                                  value.docs
                                                      .forEach((element) async {
                                                    final cid = element
                                                        .data()['CustomerID']
                                                        .toString()
                                                        .trim();
                                                    print(
                                                        'This is the element data for customer ${element.data()['CustomerID']}');
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Customers')
                                                        .doc(cid)
                                                        .collection('cart')
                                                        .doc(element.id)
                                                        .update({
                                                      'Discount': 'false',
                                                      'Discount percent': '0',
                                                      'New price': '0'
                                                    });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Customers')
                                                        .doc(cid)
                                                        .update({
                                                      'Total':
                                                          FieldValue.increment(
                                                              newPrice)
                                                    });
                                                  });
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "$offer% Discount has been added",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    backgroundColor:
                                                        Colors.black54,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                String newPrice = (widget
                                                            .productPrice -
                                                        ((offer / 100) *
                                                            widget
                                                                .productPrice))
                                                    .toString();
                                                oldPrice = double.parse(
                                                    widget.productNewPrice);
                                                print('here look $oldPrice');
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'ProductsCollection')
                                                    .doc(widget.productType)
                                                    .collection('Products')
                                                    .doc(widget.productID)
                                                    .update({
                                                  'Discount': 'true',
                                                  'Discount percent': '$offer',
                                                  'New price': newPrice
                                                });
                                                await FirebaseFirestore.instance
                                                    .collectionGroup('cart')
                                                    .where('ProductID',
                                                        isEqualTo:
                                                            widget.productID)
                                                    .get()
                                                    .then((value) {
                                                  value.docs
                                                      .forEach((element) async {
                                                    final cid = element
                                                        .data()['CustomerID']
                                                        .toString()
                                                        .trim();
                                                    print(
                                                        'This is the element data for customer ${element.data()['CustomerID']}');
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Customers')
                                                        .doc(cid)
                                                        .collection('cart')
                                                        .doc(element.id)
                                                        .update({
                                                      'Discount': 'true',
                                                      'Discount percent':
                                                          '$offer',
                                                      'New price': newPrice
                                                    });
                                                    //todo: This shit still needs work, logic is not correct
                                                    if (oldPrice == 0)
                                                      oldPrice = double.parse(
                                                              newPrice) *
                                                          2;
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Customers')
                                                        .doc(cid)
                                                        .update({
                                                      'Total':
                                                          FieldValue.increment(
                                                              -oldPrice)
                                                    });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Customers')
                                                        .doc(cid)
                                                        .update({
                                                      'Total':
                                                          FieldValue.increment(
                                                              double.parse(
                                                                  newPrice))
                                                    });
                                                  });
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_offer_outlined,
                                      color: Color(0xFF731800),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Edit This Product Offer",
                                      style: TextStyle(
                                        color: Color(0xFF731800),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                "Go Back",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Edit'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                Spacer(),
                FlatButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('ProductsCollection')
                        .doc(widget.productType)
                        .collection('Products')
                        .doc(widget.productID)
                        .delete();
                    Fluttertoast.showToast(
                        msg: "Product removed",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.black54,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    await FirebaseFirestore.instance
                        .collectionGroup('cart')
                        .where('ProductID', isEqualTo: widget.productID)
                        .get()
                        .then((value) {
                      value.docs.forEach((element) async {
                        final cid =
                            element.data()['CustomerID'].toString().trim();
                        print(
                            'This is the element data for customer ${element.data()['CustomerID']}');
                        await FirebaseFirestore.instance
                            .collection('Customers')
                            .doc(cid)
                            .collection('cart')
                            .doc(element.id)
                            .delete();
                      });
                    });
                    await FirebaseFirestore.instance
                        .collectionGroup('rated products')
                        .where('ProductID', isEqualTo: widget.productID)
                        .get()
                        .then((value) {
                      value.docs.forEach((element) async {
                        final cid =
                            element.data()['CustomerID'].toString().trim();
                        print(
                            'This is the element data for customer ${element.data()['CustomerID']}');
                        await FirebaseFirestore.instance
                            .collection('Customers')
                            .doc(cid)
                            .collection('cart')
                            .doc(element.id)
                            .delete();
                      });
                    });
                    Reference firebaseStorageRef =
                        FirebaseStorage.instance.ref();
                    firebaseStorageRef
                        .child(
                            "ProductImage/${widget.productType}/${widget.productID}/${widget.productName}")
                        .delete()
                        .whenComplete(() => print('delete success'));
                  },
                  child: Text('Delete'),
                  color: Colors.red,
                  textColor: Colors.white,
                ),
                Spacer(flex: 3),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.productRating}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.star_outlined,
                        color: Colors.yellow,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

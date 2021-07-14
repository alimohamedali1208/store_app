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
import 'package:store_app/SellerAddOfferOnCategory.dart';
import 'package:store_app/UserSeller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/addCategory.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:store_app/productClass.dart';
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
                  UserSeller.typeList.clear();
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
        appBar: AppBar(
          title: Text(seller.firstName),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: Color(0xFF731800),
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddOfferOnCategory()));
                  },
                  title: Text('Add offer on category'),
                  leading: Icon(Icons.local_offer_sharp, color: Colors.black),
                ),
              ),
              Divider(color: Colors.black),
              /*InkWell(
                child: ListTile(
                  onTap: () {},
                  title: Text('Settings'),
                  leading: Icon(Icons.settings, color: Colors.black),
                ),
              ),*/
              InkWell(
                child: ListTile(
                  onTap: () {
                    _auth.signOut();
                    seller.lastName = 'temp';
                    seller.firstName = 'temp';
                    UserSeller.typeList.clear();
                    Navigator.pushNamed(context, Home.id);
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
              var productview;
              List<SingleProduct> productsview = [];
              for (var product in products) {
                ProductClass productInfo = ProductClass();
                if (_auth.currentUser.uid == product.data()['SellerID']) {
                  productInfo.name = product.data()['Product Name'];
                  productInfo.description = product.data()['Description'];
                  productInfo.price = (product.data()['Price']).toDouble();
                  productInfo.discount = product.data()['Discount'];
                  productInfo.discountPercentage =
                      product.data()['Discount percent'];
                  productInfo.newPrice = product.data()['New price'];
                  productInfo.img = product.data()['imgURL'];
                  productInfo.type = product.data()['type'];
                  productInfo.rate = product.data()['Rating'];
                  productInfo.quantity = product.data()['Quantity'];
                  productInfo.id = product.id;
                  if (productInfo.type == 'Mobiles') {
                    productInfo.storage = product.data()['Storage'];
                    productInfo.battery = product.data()['Battery'];
                    productInfo.memory = product.data()['Memory'];
                    productInfo.camera = product.data()['Camera'];
                    productInfo.os = product.data()['OS'];
                    productInfo.brand = product.data()['Brand Name'];
                    productInfo.screenSize = product.data()['Screen Size'];
                    productInfo.storageUnit = product.data()['Storage Unit'];
                  } else if (productInfo.type == 'Laptops') {
                    productInfo.storage = product.data()['Storage'];
                    productInfo.battery = product.data()['Battery'];
                    productInfo.memory = product.data()['Memory'];
                    productInfo.os = product.data()['OS'];
                    productInfo.brand = product.data()['Brand Name'];
                    productInfo.screenSize = product.data()['ScreenSize'];
                    productInfo.cpu = product.data()['CPU'];
                    productInfo.gpu = product.data()['GPU'];
                  }
                  productview = SingleProduct(
                    prd: productInfo,
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
  ProductClass prd;

  SingleProduct({this.prd});

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  final _formKey = GlobalKey<FormState>();

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
                      children: [
                        Text(
                          "${widget.prd.price} EGP",
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.prd.newPrice} EGP",
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
                                    if (widget.prd.type == 'Laptops') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => editLaptops(
                                                    pRD: widget.prd,
                                                  )));
                                    } else if (widget.prd.type ==
                                        'AirConditioner') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editAirConditioner()));
                                    } else if (widget.prd.type == 'Cameras') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editCameras()));
                                    } else if (widget.prd.type ==
                                        'CameraAccessories') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editCameraAccessory()));
                                    } else if (widget.prd.type ==
                                        'CameraAccessories') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editCameraAccessory()));
                                    } else if (widget.prd.type ==
                                        'OtherElectronics') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editElectronics()));
                                    } else if (widget.prd.type == 'Fashion') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editFashion()));
                                    } else if (widget.prd.type == 'Fridges') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editFridge()));
                                    } else if (widget.prd.type == 'Jewelry') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editJewelary()));
                                    } else if (widget.prd.type == 'Mobiles') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => editMobile(
                                                    pRD: widget.prd,
                                                  )));
                                    } else if (widget.prd.type == 'OtherHome') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editHomeAppliances()));
                                    } else if (widget.prd.type == 'OtherPC') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editPCAccessories()));
                                    } else if (widget.prd.type == 'Printers') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editPrinter()));
                                    } else if (widget.prd.type ==
                                        'Projectors') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editProjector()));
                                    } else if (widget.prd.type ==
                                        'StorageDevice') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  editStorageDevice()));
                                    } else if (widget.prd.type == 'TV') {
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
                                    Fluttertoast.showToast(
                                        msg: "Uploading new product picture");
                                    if (_image == null) {
                                    } else {
                                      Reference firebaseStorageRef =
                                          FirebaseStorage.instance.ref().child(
                                              'ProductImage/${widget.prd.type}/${widget.prd.id}/${widget.prd.name}');
                                      UploadTask uploadTask =
                                          firebaseStorageRef.putFile(_image);
                                      TaskSnapshot taskSnapshot =
                                          await uploadTask
                                              .whenComplete(() => null);
                                      //update product img url
                                      String picURL;
                                      await taskSnapshot.ref
                                          .getDownloadURL()
                                          .then((value) => picURL = value);
                                      FirebaseFirestore.instance
                                          .collection('ProductsCollection')
                                          .doc(widget.prd.type)
                                          .collection('Products')
                                          .doc(widget.prd.id)
                                          .update({'imgURL': picURL});

                                      Fluttertoast.showToast(
                                          msg: "Uploading new product picture");
                                    }
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
                                              "Remove Discount",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: (widget.prd.discount ==
                                                    'false')
                                                ? null
                                                : () async {
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
                                                      fontSize: 16.0,
                                                    );
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'ProductsCollection')
                                                        .doc(widget.prd.type)
                                                        .collection('Products')
                                                        .doc(widget.prd.id)
                                                        .update({
                                                      'Discount': 'false',
                                                      'Discount percent': '0',
                                                      'New price': '0'
                                                    });
                                                    //Remove edited product from any customer cart
                                                    await removeEditedProductFromCart();
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
                                              if (offer == 0 || offer == null) {
                                                Fluttertoast.showToast(
                                                  msg: "Insert number first",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  backgroundColor:
                                                      Colors.black54,
                                                  gravity: ToastGravity.BOTTOM,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              } else {
                                                // Inserting new discount
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "$offer% Discount has been added",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  backgroundColor:
                                                      Colors.black54,
                                                  gravity: ToastGravity.BOTTOM,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                                String newPrice = (widget
                                                            .prd.price -
                                                        ((offer / 100) *
                                                            widget.prd.price))
                                                    .toString();
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'ProductsCollection')
                                                    .doc(widget.prd.type)
                                                    .collection('Products')
                                                    .doc(widget.prd.id)
                                                    .update({
                                                  'Discount': 'true',
                                                  'Discount percent': '$offer',
                                                  'New price': newPrice
                                                });
                                                Navigator.of(context).pop();
                                                //Remove edited product from any customer cart
                                                await removeEditedProductFromCart();
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
                    //Deleting product from products collection
                    await FirebaseFirestore.instance
                        .collection('ProductsCollection')
                        .doc(widget.prd.type)
                        .collection('Products')
                        .doc(widget.prd.id)
                        .delete();
                    Fluttertoast.showToast(
                        msg: "Product removed",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.black54,
                        gravity: ToastGravity.BOTTOM,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    //Decreasing the counter of that type of products in sellers account
                    FirebaseFirestore.instance
                        .collection('Sellers')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .update({
                      'Type${widget.prd.type}': FieldValue.increment(-1)
                    });
                    //removing it from local class
                    if(widget.prd.type == 'Mobiles'){
                      UserSeller.typeMobiles--;
                      if (UserSeller.typeMobiles < 1) {
                        UserSeller.typeList.remove("Mobiles");
                      }
                    }
                    else if(widget.prd.type == 'Laptops') {
                      UserSeller.typeLaptops--;
                      if (UserSeller.typeLaptops < 1) {
                        UserSeller.typeList.remove("Laptops");
                      }
                    }
                    else if(widget.prd.type == 'Fridges') {
                      UserSeller.typeFridges--;
                      if (UserSeller.typeFridges < 1) {
                        UserSeller.typeList.remove("Fridges");
                      }
                    }
                    else if(widget.prd.type == 'AirConditioner') {
                      UserSeller.typeAirConditioner--;
                      if (UserSeller.typeAirConditioner < 1) {
                        UserSeller.typeList.remove("AirConditioner");
                      }
                    }
                    else if(widget.prd.type == 'OtherElectronics') {
                      UserSeller.typeOtherElectronics--;
                      if (UserSeller.typeOtherElectronics < 1) {
                        UserSeller.typeList.remove("OtherElectronics");
                      }
                    }
                    //removing product from customers: cart, rated products, and favorites
                    await FirebaseFirestore.instance
                        .collectionGroup('cart')
                        .where('ProductID', isEqualTo: widget.prd.id)
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
                        .where('ProductID', isEqualTo: widget.prd.id)
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
                            .collection('rated products')
                            .doc(element.id)
                            .delete();
                      });
                    });
                    //Deleting product picture from cloud storage
                    Reference firebaseStorageRef =
                        FirebaseStorage.instance.ref();
                    firebaseStorageRef
                        .child(
                            "ProductImage/${widget.prd.type}/${widget.prd.id}/${widget.prd.name}")
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
                        '${widget.prd.rate}',
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

  Future removeEditedProductFromCart() async {
    await FirebaseFirestore.instance
        .collectionGroup('cart')
        .where('ProductID', isEqualTo: widget.prd.id)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        final cid = element.data()['CustomerID'].toString().trim();
        print(
            'This is the element data for customer ${element.data()['CustomerID']}');
        String changeFlag = element.data()['ChangeFlag'];
        //Check if cart was modified before
        if (changeFlag == 'false') {
          await FirebaseFirestore.instance
              .collection('Customers')
              .doc(cid)
              .collection('cart')
              .doc(element.id)
              .update({'ChangeFlag': 'true'});
          final discountFlag = element.data()['Discount'];
          String oldPrice;
          //Check if it had a discount
          if (discountFlag == 'true') {
            oldPrice = element.data()['New price'];
          } else {
            oldPrice = element.data()['Price'].toString();
          }
          await FirebaseFirestore.instance
              .collection('Customers')
              .doc(cid)
              .update({'Total': FieldValue.increment(-double.parse(oldPrice))});
        }
      });
    });
  }
}

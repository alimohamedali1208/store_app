import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/UserSeller.dart';

class addCamera extends StatefulWidget {
  @override
  _addCameraState createState() => _addCameraState();
}

class _addCameraState extends State<addCamera> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  File _image;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _addCameraFormKey = GlobalKey<FormState>();
  bool validate = false;
  String description, name, megaPixel, quantity, opticalZoom, screenSize;
  String ddBrand = 'Canon';
  String ddDigitalCameraType = 'Compact Camera';
  String ddDisplayType = 'LCD';
  String picURL;
  String productID;
  List<String> indexList = [];

  double price;

  //Getting the image
  Future getImage() async {
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    if (_image!=null) {
      _firestore
          .collection('ProductsCollection')
          .doc('Cameras')
          .collection('Products')
          .add({
        'Brand Name': ddBrand,
        'Product Name': name,
        'CreatedAt': Timestamp.now(),
        'Description': description,
        'Mega Pixel': megaPixel,
        'Optical Zoom': opticalZoom,
        'Screen Size': screenSize,
        'Screen Type': ddDisplayType,
        'Camera Type': ddDigitalCameraType,
        'Price': price,
        'New price': '0',
        'Quantity': quantity,
        'Rating': '0',
        '1 star rate': 0,
        '2 star rate': 0,
        '3 star rate': 0,
        '4 star rate': 0,
        '5 star rate': 0,
        'Discount': 'false',
        'Discount percent': '0',
        'Seller ID': _auth.currentUser.uid,
        'Seller Email': _auth.currentUser.email,
        'type': 'Cameras',
        'searchIndex': indexList
      }).then((value) async {
        productID = value.id;
        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('ProductImage/Cameras/$productID/$name');
        UploadTask uploadTask = firebaseStorageRef.putFile(_image);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        taskSnapshot.ref.getDownloadURL().then(
              (value) => print('done $value'),
            );
        await taskSnapshot.ref.getDownloadURL().then((value) => picURL = value);
        _firestore
            .collection('ProductsCollection')
            .doc('Cameras')
            .collection('Products')
            .doc(productID)
            .update({'imgURL': picURL});
      });
      _firestore
          .collection('Sellers')
          .doc(_auth.currentUser.uid)
          .update({'TypeCameras': FieldValue.increment(1)});
      if(!UserSeller.typeList.contains("Cameras"))
        UserSeller.typeList.add("Cameras");
      Fluttertoast.showToast(
          msg: "Product has been added",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
    }
    else
      Fluttertoast.showToast(msg: "Please add an image to continue");
  }

  //toggling auto validate
  void _toggleValidate() {
    setState(() {
      validate = !validate;
    });
  }

  String validateEmpty(String value) {
    if (value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add a Camera"),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Color(0xFF731800),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.camera_alt,
                ),
                Container(
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Form(
              key: _addCameraFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Device name',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        name = value.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        description = value.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      enableInteractiveSelection: false,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]")),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        price = double.parse(value.trim());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      enableInteractiveSelection: false,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]")),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        quantity = value.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Screen Size',
                        hintText: "Size in inches",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        screenSize = value.trim() + " inches";
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]")),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Megapixel',
                        hintText: "Just provide the number, we'll add the 'Mp'",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        megaPixel = value.trim() + " Megapixels";
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]")),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Optical Zoom',
                        hintText: "Just provide the number, we'll add the 'x'",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        opticalZoom = value.trim() + "x";
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                        value: ddBrand,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Brand",
                        ),
                        validator: validateEmpty,
                        onChanged: (String newValue) {
                          setState(() {
                            ddBrand = newValue;
                          });
                        },
                        items: <String>[
                          'Canon',
                          'Logitech',
                          'Samsung',
                          'Ugreen',
                          'Sony',
                          'Other',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                        value: ddDigitalCameraType,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Digital Camera Type",
                        ),
                        validator: validateEmpty,
                        onChanged: (String newValue) {
                          setState(() {
                            ddDigitalCameraType = newValue;
                          });
                        },
                        items: <String>[
                          'Compact Camera',
                          'Sir Camera',
                          'Mirror Camera',
                          'Long Zoom Camera',
                          'Point And Shoot',
                          'Other',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                        value: ddDisplayType,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Display Type",
                        ),
                        validator: validateEmpty,
                        onChanged: (String newValue) {
                          setState(() {
                            ddDisplayType = newValue;
                          });
                        },
                        items: <String>[
                          'LCD',
                          'Analog',
                          'Digital',
                          'LED',
                          'Other'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                  SizedBox(height: 90)
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        backgroundColor: Color(0xFF731800),
        child: Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              color: Color(0xFF731800),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
                top: Radius.circular(30),
              )),
              child: Text(
                'Add product',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_addCameraFormKey.currentState.validate()) {
                  _addCameraFormKey.currentState.save();
                  List<String> splitlist = name.split(" ");
                  int j = splitlist[0].length + 1;

                  for (int i = 0; i < splitlist.length; i++) {
                    for (int y = 1; y < splitlist[i].length + 1; y++) {
                      indexList.add(splitlist[i].substring(0, y).toLowerCase());
                    }
                  }
                  for (j; j < name.length + 1; j++)
                    indexList.add(name.substring(0, j).toLowerCase());

                  uploadImageToFirebase(context);

                } else {
                  _toggleValidate();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

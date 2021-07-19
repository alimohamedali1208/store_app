import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../productClass.dart';

class editLaptops extends StatefulWidget {
  ProductClass prd;

  editLaptops({this.prd});

  @override
  _editLaptopsState createState() => _editLaptopsState();
}

class _editLaptopsState extends State<editLaptops> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool showSpinner = false;
  File _image;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _addLaptopFormKey = GlobalKey<FormState>();
  bool validate = false;
  String CPU,
      GPU,
      battery,
      description,
      memory,
      name,
      searchKey,
      screenSize,
      quantity,
      storage;
  String ddBrand = 'HP';
  String ddOS = 'Windows';
  String ddRamCapacity = 'GB';
  String ddStorageCapacity = 'GB';
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
    _firestore
        .collection('ProductsCollection')
        .doc('Laptops')
        .collection('Products')
        .add({
      'Brand Name': ddBrand,
      'Product Name': name,
      'CreatedAt': Timestamp.now(),
      'Description': description,
      'CPU': CPU,
      'GPU': GPU,
      'Battery': battery,
      'Memory': memory,
      'ScreenSize': screenSize,
      'Storage': storage,
      'OS': ddOS,
      'Price': price,
      'Quantity': quantity,
      'Rating': 0,
      'SellerID': _auth.currentUser.uid,
      'Seller Email': _auth.currentUser.email,
      'type': 'Laptops',
      'searchIndex': indexList
    }).then((value) async {
      productID = value.id;
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('ProductImage/Laptops/$productID/$name');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print('done $value'),
          );
      await taskSnapshot.ref.getDownloadURL().then((value) => picURL = value);
      _firestore
          .collection('ProductsCollection')
          .doc('Laptops')
          .collection('Products')
          .doc(productID)
          .update({'imgURL': picURL});
    });
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
        title: Text("Edit Laptop"),
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
            alignment: Alignment.center,
            child: Form(
              key: _addLaptopFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      autovalidate: validate,
                      validator: validateEmpty,
                      initialValue: widget.prd.name,
                      decoration: InputDecoration(
                        labelText: 'Laptop name',
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
                      autovalidate: validate,
                      validator: validateEmpty,
                      initialValue: widget.prd.gpu,
                      decoration: InputDecoration(
                        labelText: 'GPU',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        GPU = value.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      autovalidate: validate,
                      validator: validateEmpty,
                      initialValue: widget.prd.cpu,
                      decoration: InputDecoration(
                        labelText: 'CPU',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        CPU = value.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autovalidate: validate,
                      initialValue: widget.prd.description,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            flex: 2,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              autovalidate: validate,
                              validator: validateEmpty,
                              initialValue: widget.prd.memory,
                              decoration: InputDecoration(
                                labelText: 'Ram',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value) {
                                memory = value.trim();
                              },
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: ddRamCapacity,
                                  items: ['GB', 'MB', 'TB']
                                      .map((String unit) =>
                                          DropdownMenuItem<String>(
                                              value: unit, child: Text(unit)))
                                      .toList(),
                                  onChanged: (value) => setState(() {
                                        ddRamCapacity = value;
                                      })),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      initialValue: widget.prd.price.toString(),
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
                      initialValue: widget.prd.quantity,
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
                      initialValue: widget.prd.screenSize,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Screen size',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        screenSize = value.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      initialValue: widget.prd.battery,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Battery',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        battery = value.trim();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            flex: 2,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              autovalidate: validate,
                              validator: validateEmpty,
                              initialValue: widget.prd.storage.toString(),
                              decoration: InputDecoration(
                                labelText: 'Storage',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value) {
                                storage = value.trim();
                              },
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  value: ddStorageCapacity,
                                  items: ['GB', 'MB', 'TB']
                                      .map((String unit) =>
                                          DropdownMenuItem<String>(
                                              value: unit, child: Text(unit)))
                                      .toList(),
                                  onChanged: (value) => setState(() {
                                        ddStorageCapacity = value;
                                      })),
                            ),
                          ),
                        )
                      ],
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
                        value: ddOS,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Operating System",
                        ),
                        validator: validateEmpty,
                        onChanged: (String newValue) {
                          setState(() {
                            ddOS = newValue;
                          });
                        },
                        items: <String>[
                          'Windows',
                          'DOS',
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
                          'Asus',
                          'Samsung',
                          'Dell',
                          'HP',
                          'Lenovo',
                          'MSI',
                          'Razer',
                          'Acer',
                          'Microsoft',
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
                  SizedBox(
                    height: 90,
                  ),
                ],
              ),
            ),
          ),
        ],
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
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_addLaptopFormKey.currentState.validate()) {
                  _addLaptopFormKey.currentState.save();
                  List<String> splitlist = name.split(" ");
                  int j = splitlist[0].length + 1;

                  for (int i = 0; i < splitlist.length; i++) {
                    for (int y = 1; y < splitlist[i].length + 1; y++) {
                      indexList.add(splitlist[i].substring(0, y).toLowerCase());
                    }
                  }
                  for (j; j < name.length + 1; j++)
                    indexList.add(name.substring(0, j).toLowerCase());
                  print(indexList);
                  uploadImageToFirebase(context);
                  Fluttertoast.showToast(
                      msg: 'Product has been updated',
                      backgroundColor: Colors.black54);
                  Navigator.pop(context);
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

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class addLaptop extends StatefulWidget {
  @override
  _addLaptopState createState() => _addLaptopState();
}

class _addLaptopState extends State<addLaptop> {
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
      'Brand': ddBrand,
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
      'Seller Email':_auth.currentUser.email,
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
        title: Text("Add a laptop"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
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
              key: _addLaptopFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      autovalidate: validate,
                      validator: validateEmpty,
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
                      decoration: InputDecoration(
                        labelText: 'Ram',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        memory = value.trim() + " GB";
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
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Storage',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        storage = value.trim() + " GB";
                      },
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Operating system'),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      value: ddOS,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 10,
                      elevation: 10,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          ddOS = newValue;
                        });
                      },
                      items: <String>[
                        'Windows',
                        'Dos',
                        'Other',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Brand'),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      value: ddBrand,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 10,
                      elevation: 10,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 1,
                        color: Colors.black,
                      ),
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
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        backgroundColor: Colors.blueGrey[900],
        child: Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              color: Colors.blueGrey[900],
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
                  Navigator.pop(context);

                } else {
                  _toggleValidate();
                }
              },
              child: Text(
                'Add product',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

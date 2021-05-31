import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class editPrinter extends StatefulWidget {
  @override
  _editPrinterState createState() => _editPrinterState();
}

class _editPrinterState extends State<editPrinter> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  File _image;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _addPcAccessoriesFormKey = GlobalKey<FormState>();
  bool validate = false;
  String description, name, quantity;
  String ddPrinterType = 'Inkjet printer';
  String ddColor = 'Black';
  String ddBrand = 'Samsung';
  String ddPaperSize = 'Up to A3';
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
        .doc('Printers')
        .collection('Products')
        .add({
      'Brand Name': ddBrand,
      'Product Name': name,
      'CreatedAt': Timestamp.now(),
      'Description': description,
      'Printer Type': ddPrinterType,
      'Paper Type': ddPaperSize,
      'Color': ddColor,
      'Price': price,
      'Quantity': quantity,
      'Rating': 0,
      'SellerID': _auth.currentUser.uid,
      'Seller Email': _auth.currentUser.email,
      'type': 'Printers',
      'searchIndex': indexList,
    }).then((value) async {
      productID = value.id;
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('ProductImage/Printers/$productID/$name');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print('done $value'),
          );
      await taskSnapshot.ref.getDownloadURL().then((value) => picURL = value);
      _firestore
          .collection('ProductsCollection')
          .doc('Printers')
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          title: Column(
            children: [
              SizedBox(height: 20),
              Text("edit a Printer"),
            ],
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: Color(0xFF731800),
        ),
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
              key: _addPcAccessoriesFormKey,
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
                    padding: const EdgeInsets.all(8.0),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                        value: ddPrinterType,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Printer Type",
                        ),
                        validator: validateEmpty,
                        onChanged: (String newValue) {
                          setState(() {
                            ddPrinterType = newValue;
                          });
                        },
                        items: <String>[
                          'Inkjet printer',
                          'Laser printer',
                          'Receipt printer',
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
                        value: ddColor,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Color",
                        ),
                        validator: validateEmpty,
                        onChanged: (String newValue) {
                          setState(() {
                            ddColor = newValue;
                          });
                        },
                        items: <String>[
                          'Black',
                          'White',
                          'Multicolor',
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
                        value: ddPaperSize,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Paper Size",
                        ),
                        validator: validateEmpty,
                        onChanged: (String newValue) {
                          setState(() {
                            ddPaperSize = newValue;
                          });
                        },
                        items: <String>[
                          'Up to A3',
                          'Up to A4',
                          'Up to A5',
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
                          'Samsung',
                          'HP',
                          'Canon',
                          'Xprinter',
                          'Toshiba',
                          'Epson',
                          'other',
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
                if (_addPcAccessoriesFormKey.currentState.validate()) {
                  _addPcAccessoriesFormKey.currentState.save();
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SellerAddMobile extends StatefulWidget {
  @override
  _SellerAddMobileState createState() => _SellerAddMobileState();
}

class _SellerAddMobileState extends State<SellerAddMobile> {
  var _image;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _addMobileFormKey = GlobalKey<FormState>();
  bool validate = false;
  String camera,
      battery,
      description,
      memory,
      name,
      searchKey,
      screenSize,
      quantity,
      seller,
      storage;
  String ddBrand;
  String ddOS;

  double price;

  //Getting the image
  Future getImage() async {
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
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
        title: Text("Add a mobile"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Icon(Icons.camera_alt),
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
              key: _addMobileFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'phone name',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        name = value.trim();
                        searchKey = name.substring(0, 1);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Battery size',
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
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Camera',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        camera = value.trim();
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
                      autovalidate: validate,
                      validator: validateEmpty,
                      decoration: InputDecoration(
                        labelText: 'Phone ram',
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
                        labelText: 'Phone storage',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        storage = value.trim() + " GB";
                      },
                    ),
                  ),
                  DropdownButton<String>(
                    hint: Text('Operating system'),
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
                      'IOS',
                      'Android',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    hint: Text('Brand'),
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
                      'Apple',
                      'Samsung',
                      'Huawei',
                      'Nokia',
                      'Sony',
                      'HTC',
                      'Lenovo',
                      'SICO Technology',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                if (_addMobileFormKey.currentState.validate()) {
                  _addMobileFormKey.currentState.save();
                  print("name $name brand $ddBrand battery $battery os $ddOS");
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

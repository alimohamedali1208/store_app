import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/productClass.dart';

class editMobile extends StatefulWidget {
  ProductClass prd;
  editMobile({this.prd});

  @override
  _editMobileState createState() => _editMobileState();
}

class _editMobileState extends State<editMobile> {
  final _firestore = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _addMobileFormKey = GlobalKey<FormState>();
  bool validate = false;
  String camera, battery, description, memory, name, screenSize, quantity;
  int storage;
  String ddBrand = 'Apple';
  String ddOS = 'IOS';
  String ddRamCapacity = 'GB';
  String ddStorageCapacity = 'GB';
  String picURL;
  String productID;
  List<String> indexList = [];
  double price;

  Future updateProduct(BuildContext context) async {
    _firestore
        .collection('ProductsCollection')
        .doc('Mobiles')
        .collection('Products')
        .doc('${widget.prd.id}')
        .update({
      'Brand Name': ddBrand,
      'Product Name': name,
      'Description': description,
      'Battery': battery,
      'Camera': camera,
      'Storage': storage,
      'Storage Unit': ddStorageCapacity,
      'Screen Size': screenSize,
      'Memory': memory,
      'Memory Unit':ddRamCapacity,
      'OS': ddOS,
      'Price': price,
      'New price': '0',
      'Discount': 'false',
      'Discount percent': '0',
      'Quantity': quantity,
      'searchIndex': indexList,
    }).then((_) {
      print('Update Success');
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
        title: Text("edit a Mobile"),
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
              key: _addMobileFormKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      autovalidate: validate,
                      validator: validateEmpty,
                      initialValue: widget.prd.name,
                      decoration: InputDecoration(
                        labelText: 'phone name',
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
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      initialValue: widget.prd.battery,
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
                      keyboardType: TextInputType.number,
                      autovalidate: validate,
                      validator: validateEmpty,
                      initialValue: widget.prd.camera,
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
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp("[0-9]")),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Ram',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (String value) {
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
                                  items: ['GB', 'MB']
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
                      initialValue: (widget.prd.price).toString(),
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
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp("[0-9]")),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Phone Storage',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) {
                                storage = int.parse(value.trim());
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
                                  items: ['GB', 'MB']
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
                          'IOS',
                          'Android',
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
                          'Apple',
                          'Samsung',
                          'Huawei',
                          'Nokia',
                          'Sony',
                          'Oppo',
                          'HTC',
                          'Lenovo',
                          'SICO Technology',
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
                if (_addMobileFormKey.currentState.validate()) {
                  _addMobileFormKey.currentState.save();
                  List<String> splitlist = name.split(" ");
                  int j = splitlist[0].length + 1;

                  for (int i = 0; i < splitlist.length; i++) {
                    for (int y = 1; y < splitlist[i].length + 1; y++) {
                      indexList.add(splitlist[i].substring(0, y).toLowerCase());
                    }
                  }
                  for (j; j < name.length + 1; j++)
                    indexList.add(name.substring(0, j).toLowerCase());
                  updateProduct(context);
                  Fluttertoast.showToast(
                      msg: 'Product has been updated',
                      backgroundColor: Colors.black54);
                  removeEditedProductFromCart();
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

  Future removeEditedProductFromFavorites() async {
    await FirebaseFirestore.instance
        .collectionGroup('favorite')
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
              .collection('favorite')
              .doc(element.id)
              .update({'ChangeFlag': 'true'});
        }
      });
    });
  }
}

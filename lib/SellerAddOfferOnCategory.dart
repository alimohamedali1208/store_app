import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:store_app/UserSeller.dart';

class AddOfferOnCategory extends StatefulWidget {
  @override
  _AddOfferOnCategoryState createState() => _AddOfferOnCategoryState();
}

class _AddOfferOnCategoryState extends State<AddOfferOnCategory> {
  final _offersFormKey = GlobalKey<FormState>();

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Color(0xFF731800);
  }

  String validateOffer(String value) {
    if (value.isEmpty) {
      return "Please provide a value";
    } else if (!(int.parse(value) >= 5 && int.parse(value) < 100)) {
      return "Offer must be between 5 and 99";
    }
    return null;
  }

  void _toggleValidate() {
    setState(() {
      validate = !validate;
    });
  }

  //variables
  String ddCategory = UserSeller.typeList.first;
  int offer;
  bool validate = false;
  bool isChecked = false;
  bool showSpinner = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add offer on category"),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: Color(0xFF731800),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Form(
            key: _offersFormKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.only(top: 3, left: 5, right: 5),
                          ),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField(
                            autovalidate: validate,
                            value: ddCategory,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Choose Category",
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                ddCategory = newValue;
                                print(ddCategory);
                              });
                            },
                            items: UserSeller.typeList
                                .map<DropdownMenuItem<String>>((var value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autovalidate: validate,
                          validator: validateOffer,
                          enableInteractiveSelection: false,
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                              labelText: 'Offer',
                              hintText: "Enter an offer value",
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(
                                fontSize: 10,
                              )),
                          onSaved: (value) {
                            offer = int.parse(value.trim());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(onPressed: ()async{
                  await removeOfferFromProducts();
                }, child: Text("Remove offer from products"))
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Flexible(
                //         flex: 1,
                //         child: Text(
                //           "Notify customers via email",
                //           style: TextStyle(
                //             fontSize: 16,
                //           ),
                //         )),
                //     Flexible(
                //       flex: 1,
                //       child: Checkbox(
                //         checkColor: Colors.white,
                //         fillColor: MaterialStateProperty.resolveWith(getColor),
                //         value: isChecked,
                //         onChanged: (bool value) {
                //           setState(() {
                //             isChecked = value;
                //           });
                //         },
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
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
                  'Add offer',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_offersFormKey.currentState.validate()) {
                    _offersFormKey.currentState.save();
                    print("$ddCategory  $offer  $isChecked");
                    Fluttertoast.showToast(
                        msg: "Updating your $ddCategory Offer");
                    setState(() {
                      showSpinner = true;
                    });
                    FirebaseFirestore.instance
                        .collection('ProductsCollection')
                        .doc(ddCategory)
                        .collection('Products')
                        .where('Seller Email',
                            isEqualTo: _auth.currentUser.email)
                        .get()
                        .then((value) {
                      value.docs.forEach((element) async {
                        String pid = element.id;
                        num price = await element.data()['Price'];
                        String newPrice =
                            (price - ((offer / 100) * price)).toString();
                        print("${element.id}  $price  $newPrice");
                        await FirebaseFirestore.instance
                            .collection('ProductsCollection')
                            .doc(ddCategory)
                            .collection('Products')
                            .doc(pid)
                            .update({
                          'Discount': 'true',
                          'Discount percent': '$offer',
                          'New price': newPrice
                        });
                        //remove product from any customer cart
                        await removeProductFromCart(pid);
                        setState(() {
                          showSpinner = false;
                        });
                        Fluttertoast.showToast(
                            msg: "$ddCategory products have been updated!");
                      });
                    });
                  } else {
                    _toggleValidate();
                  }
                },
              ),
            ))));
  }

  Future<void> removeOfferFromProducts() async {
    print("$ddCategory");
    Fluttertoast.showToast(msg: "Updating your $ddCategory Offer");
    setState(() {
      showSpinner = true;
    });
    FirebaseFirestore.instance
        .collection('ProductsCollection')
        .doc(ddCategory)
        .collection('Products')
        .where('Seller Email', isEqualTo: _auth.currentUser.email)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        String pid = element.id;
        await FirebaseFirestore.instance
            .collection('ProductsCollection')
            .doc(ddCategory)
            .collection('Products')
            .doc(pid)
            .update({
          'Discount': 'false',
          'Discount percent': '0',
          'New price': '0'
        });
        //remove product from any customer cart
        await removeProductFromCart(pid);
        setState(() {
          showSpinner = false;
        });
        Fluttertoast.showToast(msg: "$ddCategory products have been updated!");
      });
    });
  }

  Future removeProductFromCart(String pid) async {
    await FirebaseFirestore.instance
        .collectionGroup('cart')
        .where('ProductID', isEqualTo: pid)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        final cid = element.data()['CustomerID'].toString().trim();
        String quantity = element.data()['Ordered Quantity'];
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
              .update({'Total': FieldValue.increment(-(double.parse(oldPrice)*double.parse(quantity)))});
        }
      });
    });
  }
}

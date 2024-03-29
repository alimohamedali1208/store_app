import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/UserSeller.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';

import 'Home.dart';
import 'ResetPassword.dart';

//  ABSOLUTELY DISGUSTING
//           ||
//           ||
//           ||
//           ▼▼

class SellerEditProfile extends StatefulWidget {
  @override
  _SellerEditProfileState createState() => _SellerEditProfileState();
}

enum SingingCharacter { Male, Female }

class _SellerEditProfileState extends State<SellerEditProfile> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String fname, lname, phone, email, companyName, tax;
  UserCustomer customer = UserCustomer();
  UserSeller seller = UserSeller();
  bool flagSellerDatabase = false;
  bool flagSellerTextFields = false;
  bool showSpinner = false;
  bool validate = false;
  // Initially password is obscure
  bool _obscureText = true;
  SingingCharacter _character = SingingCharacter.Male;
  String dropdownValue = 'Customer';
  final _sellerEditProfileFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //toggling auto validate
  void _toggleValidate() {
    setState(() {
      validate = !validate;
    });
  }

  //Showing snackbar
  void _showSnackbar(String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      // duration: const Duration(seconds: 10),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  //toggling show\hide password
  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //validator methods
  String validateEmail(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return "please provide an email";
    } else if (!EmailValidator.validate(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String validatePassword(String value) {
    value = value.trim();
    //Some beafy reagular expression
    // Pattern pattern =
    //     r'^(?=.*?[A-Z])(/^.{6,}$/)(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    // RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return "please provide a password";
    } else if (value.length < 6) {
      return "Your password must be at least 6 characters long";
    }

    //else if (!regex.hasMatch(value)) {
    //   return "Your password must contain the following\n" +
    //       "Minimum 6 characters \n" +
    //       "Minimum 1 Upper case\n" +
    //       "Minimum 1 lowercase\n" +
    //       "Minimum 1 Numeric Number\n" +
    //       "Minimum 1 Special Character\n" +
    //       "Common Allow Character ( ! @ # \$ & * ~ )";
    // }
    return null;
  }

  String validateName(String value) {
    RegExp nameRegExp = RegExp('^[a-zA-Z\s\.]*');
    value = value.trim();
    if (value.isEmpty) {
      return "Please provide a name";
    } else if (!nameRegExp.hasMatch(value)) {
      return "Please provide a valid name";
    }
    return null;
  }

  String validatePhone(String value) {
    RegExp numberRegExp = RegExp(r'^01[0-2]{1}[0-9]{8}');
    value = value.trim();
    if (value.isEmpty) {
      return "Please provide a phone number";
    } else if (!numberRegExp.hasMatch(value)) {
      return "Please provide a valid phone number";
    }
    return null;
  }

  String validateCompanyName(String value) {
    RegExp nameRegExp = RegExp('^[a-zA-Z\s\.]*');
    value = value.trim();
    if (value.isEmpty) {
      return "Please provide a company name";
    } else if (!nameRegExp.hasMatch(value)) {
      return "Please provide a valid company name";
    }
    return null;
  }

  String validateTaxCard(String value) {
    RegExp cardRegExp = RegExp("^[0-9]+\$");
    value = value.trim();
    if (value.isEmpty) {
      return "Please provide a tax card";
    } else if (!cardRegExp.hasMatch(value)) {
      return "Please provide a valid card";
    }
    return null;
  }

  ///^.{6,}$/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Profile"),
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
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                alignment: Alignment.center,
                child: Form(
                  key: _sellerEditProfileFormKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          autovalidate: validate,
                          validator: validateName,
                          enabled: flagSellerTextFields,
                          initialValue: seller.firstName,
                          decoration: InputDecoration(
                            labelText: 'First Name:',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            fname = value.trim();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          autovalidate: validate,
                          validator: validateName,
                          enabled: flagSellerTextFields,
                          initialValue: seller.lastName,
                          decoration: InputDecoration(
                            labelText: 'Last Name:',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            lname = value.trim();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          autovalidate: validate,
                          validator: validatePhone,
                          enabled: flagSellerTextFields,
                          initialValue: seller.phone,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone:',
                            hintText: '017775000',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            phone = value.trim();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          autovalidate: validate,
                          enabled: flagSellerTextFields,
                          initialValue: seller.company,
                          validator: validateCompanyName,
                          decoration: InputDecoration(
                            labelText: 'Company name:',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            companyName = value.trim();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          autovalidate: validate,
                          initialValue: seller.tax,
                          enabled: flagSellerTextFields,
                          validator: validateTaxCard,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Tax Card:',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            tax = value.trim();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          color: Color(0xFF731800),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(30),
                            top: Radius.circular(30),
                          )),
                          onPressed: () {
                            setState(() {
                              flagSellerTextFields = true;
                            });
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(30),
                            top: Radius.circular(30),
                          )),
                          color: Color(0xFF731800),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassword()));
                          },
                          child: Text(
                            'Change Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
              onPressed: () async {
                if (_sellerEditProfileFormKey.currentState.validate()) {
                  _sellerEditProfileFormKey.currentState.save();
                  setState(() {
                    showSpinner = true;
                  });
                  seller.firstName = fname;
                  seller.lastName = lname;
                  seller.company = companyName;
                  seller.phone = phone;
                  seller.tax = tax;
                  await _firestore
                      .collection('Sellers')
                      .doc(_auth.currentUser.uid)
                      .update({
                    'FirstName': fname,
                    'LastName': lname,
                    'CompanyName': companyName,
                    'Phone': phone,
                    'TaxCard': tax
                  });
                  setState(() {
                    showSpinner = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Profile updated"),
                          content: Text(
                              "Changes will take effect after next sign in."),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _auth.signOut();
                                  seller.firstName = 'temp';
                                  seller.lastName = 'temp';
                                  UserSeller.typeList.clear();
                                  Navigator.pushNamed(context, Home.id);
                                },
                                child: Text("Logout"))
                          ],
                        );
                      });
                } else {
                  _toggleValidate();
                  _showSnackbar(
                      "Something went wrong, check the warnings above and try again");
                }
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

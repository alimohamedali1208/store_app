import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/ResetPassword.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/UserSeller.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';

//  ABSOLUTELY DISGUSTING
//           ||
//           ||
//           ||
//           ▼▼

class CustomerEditProfile extends StatefulWidget {
  @override
  _CustomerEditProfileState createState() => _CustomerEditProfileState();
}

enum SingingCharacter { Male, Female }

class _CustomerEditProfileState extends State<CustomerEditProfile> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String fname, lname, phone, email;
  UserCustomer customer = UserCustomer();

  bool flagCustomerDatabase = false;
  bool flagCustomerTextFields = false;
  bool showSpinner = false;
  bool validate = false;
  // Initially password is obscure
  bool _obscureText = true;
  SingingCharacter _character = SingingCharacter.Male;
  String dropdownValue = 'Customer';
  final _customerEditProfileFormKey = GlobalKey<FormState>();
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
    RegExp nameRegExp = RegExp('([A-Z]|[a-z])[a-zA-Z]*');
    value = value.trim();
    if (value.isEmpty) {
      return "Please provide a name";
    } else if (!nameRegExp.hasMatch(value)) {
      return "Please provide a valid name";
    } else if (value.length < 2) {
      return "name must be greater than 2 characters";
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
                  key: _customerEditProfileFormKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          autovalidate: validate,
                          validator: validateName,
                          enabled: flagCustomerTextFields,
                          initialValue: customer.firstName,
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                          ],
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
                          enabled: flagCustomerTextFields,
                          initialValue: customer.lastName,
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                          ],
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
                          enabled: flagCustomerTextFields,
                          initialValue: customer.phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[0-9]")),
                          ],
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
                              flagCustomerTextFields = true;
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
                if (_customerEditProfileFormKey.currentState.validate()) {
                  _customerEditProfileFormKey.currentState.save();
                  setState(() {
                    showSpinner = true;
                  });
                  customer.firstName = fname;
                  customer.lastName = lname;
                  customer.phone = phone;

                  await _firestore
                      .collection('Customers')
                      .doc(_auth.currentUser.uid)
                      .update({
                    'FirstName': fname,
                    'LastName': lname,
                    'Phone': phone,
                  });
                  setState(() {
                    showSpinner = false;
                  });
                  Fluttertoast.showToast(
                      msg: 'Profile updated', backgroundColor: Colors.black54);
                  Navigator.pop(context);
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

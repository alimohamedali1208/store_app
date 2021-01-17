import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/UserSeller.dart';
import 'package:store_app/loggedinhome.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';
import 'package:store_app/sellerhome.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

enum SingingCharacter { Male, Female }

class _registerState extends State<register> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String fname, lname, phone, sex = 'M', email, pass, companyName, tax;
  UserCustomer customer = UserCustomer();
  UserSeller seller = UserSeller();
  bool flagDB = false;
  bool showSpinner = false;
  bool validate = false;
  // Initially password is obscure
  bool _obscureText = true;
  SingingCharacter _character = SingingCharacter.Male;
  String dropdownValue = 'Customer';
  final _registerFormKey = GlobalKey<FormState>();
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
        title: Text("SignUp"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Form(
                key: _registerFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        autovalidate: validate,
                        validator: validateName,
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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                          child: Text('Male'),
                        ),
                        Radio(
                          activeColor: Colors.deepOrange[400],
                          value: SingingCharacter.Male,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            sex = 'M';
                            print(sex);
                            setState(
                              () {
                                _character = value;
                              },
                            );
                          },
                        ),
                        Text('Female'),
                        Radio(
                          activeColor: Colors.green[600],
                          value: SingingCharacter.Female,
                          groupValue: _character,
                          onChanged: (SingingCharacter value) {
                            sex = 'F';
                            print(sex);
                            setState(
                              () {
                                _character = value;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        autovalidate: validate,
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'somone@something.com',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          email = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          TextFormField(
                            autovalidate: validate,
                            validator: validatePassword,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'you really need a hint for this?',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              pass = value.trim();
                            },
                          ),
                          new FlatButton(
                              onPressed: _togglePassword,
                              child: new Text(_obscureText ? "Show" : "Hide"))
                        ],
                      ),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
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
                          dropdownValue = newValue;
                          if (dropdownValue == 'Seller') {
                            flagDB = true;
                          } else if (dropdownValue == 'Customer') {
                            flagDB = false;
                          }
                        });
                      },
                      items: <String>['Customer', 'Seller']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        autovalidate: validate,
                        enabled: flagDB,
                        validator: validateCompanyName,
                        decoration: InputDecoration(
                          labelText: 'Company name:',
                          hintText: 'Sony',
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
                        enabled: flagDB,
                        validator: validateTaxCard,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Tax Card:',
                          hintText: '15321',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          tax = value.trim();
                        },
                      ),
                    ),
                  ],
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
              color: Colors.blueGrey[900],
              onPressed: () async {
                if (_registerFormKey.currentState.validate()) {
                  _registerFormKey.currentState.save();
                  setState(() {
                    showSpinner = true;
                  });
                  if (flagDB) {
                    _firestore.collection('Sellers').add({
                      'FirstName': fname,
                      'LastName': lname,
                      'Phone': phone,
                      'Sex': sex,
                      'Email': email,
                      'Password': pass,
                      'CompanyName': companyName,
                      'TaxCard': tax
                    });
                    seller.firstName = fname;
                    seller.lastName = lname;
                  } else {
                    _firestore.collection('Customers').add({
                      'FirstName': fname,
                      'LastName': lname,
                      'Phone': phone,
                      'Sex': sex,
                      'Email': email,
                      'Password': pass,
                    });
                    customer.firstName = fname;
                    customer.lastName = lname;
                  }
                  try {
                    final newuser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: pass);
                    if (flagDB) {
                      Navigator.pushNamed(context, sellerhome.id);
                    } else {
                      Navigator.pushNamed(context, loggedinhome.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                    setState(() {
                      showSpinner = false;
                    });
                    _showSnackbar("Something went wrong!");
                  }
                } else {
                  _toggleValidate();
                  _showSnackbar(
                      "Something went wrong, check the warnings above and try again");
                }
              },
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/ResetPassword.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/UserSeller.dart';
import 'package:store_app/loggedinhome.dart';
import 'package:store_app/register.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';
import 'package:store_app/sellerhome.dart';

import 'VerifyScreen.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String dropdownValue = 'Customer';
  bool flagSeller = false;
  bool flagCS = false;
  UserCustomer customer = UserCustomer();
  UserSeller seller = UserSeller();
  String Email;
  String pass;
  bool showSpinner = false;
  bool validate = false;
  // Initially password is obscure
  bool _obscureText = true;
  final _loginFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Showing snackbar
  void _showSnackbar(String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      // duration: const Duration(seconds: 10),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  //toggling auto validate
  void _toggleValidate() {
    setState(() {
      validate = !validate;
    });
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
    if (value.isEmpty) {
      return "please provide a password";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
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
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autovalidate: validate,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                              hintText: 'somone@something.com',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              Email = value.trim();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                autovalidate: validate,
                                obscureText: _obscureText,
                                validator: validatePassword,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: (_obscureText)
                                          ? Icon(Icons.remove_red_eye)
                                          : Icon(Icons.remove_red_eye_outlined),
                                      onPressed: () {
                                        _togglePassword();
                                      },
                                    ),
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    icon: Icon(Icons.vpn_key)),
                                onSaved: (value) {
                                  pass = value.trim();
                                },
                              ),
                              // FlatButton(
                              //     onPressed: _togglePassword,
                              //     child: Text(_obscureText ? "Show" : "Hide")),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResetPassword()));
                                  },
                                  child: Text("Forget Password"))
                            ],
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
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
                                  flagSeller = true;
                                } else if (dropdownValue == 'Customer') {
                                  flagSeller = false;
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
                                      builder: (context) => register()));
                            },
                            child: Text(
                              'New user? Sign up here',
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
                top: Radius.circular(30),
              )),
              color: Color(0xFF731800),
              child: Text(
                'Sign in',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_loginFormKey.currentState.validate()) {
                  setState(() {
                    showSpinner = true;
                  });
                  _loginFormKey.currentState.save();
                  try {
                    //If user was a seller
                    if (flagSeller) {
                      final DBRow =
                          await _firestore.collection('Sellers').get();
                      for (var usern in DBRow.docs) {
                        final firstname = usern.get('FirstName');
                        final lastname = usern.get('LastName');
                        final email = usern.get('Email');
                        final company = usern.get('CompanyName');
                        final taxCard = usern.get('TaxCard');
                        final phone = usern.get('Phone');
                        final sex = usern.get('Sex');
                        final typeMobiles = usern.data()['TypeMobiles'];
                        final typeLaptops = usern.data()['TypeLaptops'];
                        final typeAirConditioner =
                            usern.data()['TypeAirConditioner'];
                        final typeFridges = usern.data()['TypeFridges'];
                        final typeTV = usern.data()['TypeTV'];
                        final typeProjectors = usern.data()['TypeProjectors'];
                        final typePrinters = usern.data()['TypePrinters'];
                        final typeStorageDevices =
                            usern.data()['TypeStorageDevices'];
                        final typeCameras = usern.data()['TypeCameras'];
                        final typeCameraAccessories =
                            usern.data()['TypeCameraAccessories'];
                        final typeFashion = usern.data()['TypeFashion'];
                        final typeJewelry = usern.data()['TypeJewelry'];
                        final typeOtherElectronics =
                            usern.data()['TypeOtherElectronics'];
                        final typeOtherPC = usern.data()['TypeOtherPC'];
                        final typeOtherHome = usern.data()['TypeOtherHome'];
                        if (email == Email) {
                          seller.firstName = firstname;
                          seller.lastName = lastname;
                          seller.email = email;
                          seller.company = company;
                          seller.phone = phone;
                          seller.sex = sex;
                          seller.tax = taxCard;
                          SetProductsList(
                              typeMobiles,
                              typeLaptops,
                              typeOtherElectronics,
                              typeAirConditioner,
                              typeOtherHome,
                              typeOtherPC,
                              typeFashion,
                              typeStorageDevices,
                              typeJewelry,
                              typeCameraAccessories,
                              typeCameras,
                              typePrinters,
                              typeFridges,
                              typeProjectors,
                              typeTV);
                        }
                      }
                      if (seller.firstName == 'temp') {
                        setState(() {
                          showSpinner = false;
                        });
                        _showSnackbar("Invalid email or password");
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                        final newuser = await _auth.signInWithEmailAndPassword(
                            email: Email, password: pass);
                        final user = _auth.currentUser;
                        if (user.emailVerified) {
                          Navigator.pushNamed(context, sellerhome.id);
                        } else {
                          user.sendEmailVerification();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => verifyScreen()));
                        }
                      }
                    }
                    // User was a customer
                    else {
                      final userName =
                          await _firestore.collection('Customers').get();
                      for (var usern in userName.docs) {
                        final firstname = usern.get('FirstName');
                        final lastname = usern.get('LastName');
                        final email = usern.get('Email');
                        final phone = usern.get('Phone');
                        if (email == Email) {
                          customer.firstName = firstname;
                          customer.lastName = lastname;
                          customer.phone = phone;
                        }
                      }
                      if (customer.firstName == 'temp') {
                        setState(() {
                          showSpinner = false;
                        });
                        _showSnackbar("Invalid email or password");
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                        final newuser = await _auth.signInWithEmailAndPassword(
                            email: Email, password: pass);
                        customer.userID = _auth.currentUser.uid;
                        final user = _auth.currentUser;
                        if (user.emailVerified) {
                          Navigator.pushNamed(context, loggedinhome.id);
                        } else {
                          user.sendEmailVerification();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => verifyScreen()));
                        }
                      }
                    }
                  } catch (e) {
                    print(e);
                    setState(() {
                      showSpinner = false;
                    });
                    _showSnackbar("Invalid email or password");
                  }
                } else {
                  _toggleValidate();
                  _showSnackbar(
                      "Something went wrong, check the errors above please");
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void SetProductsList(
      typeMobiles,
      typeLaptops,
      typeOtherElectronics,
      typeAirConditioner,
      typeOtherHome,
      typeOtherPC,
      typeFashion,
      typeStorageDevices,
      typeJewelry,
      typeCameraAccessories,
      typeCameras,
      typePrinters,
      typeFridges,
      typeProjectors,
      typeTV) {
    if (typeMobiles > 0) {
      UserSeller.typeList.add("Mobiles");
      UserSeller.typeMobiles = typeMobiles;
    }
    if (typeLaptops > 0) {
      UserSeller.typeList.add("Laptops");
      UserSeller.typeLaptops = typeLaptops;
    }
    if (typeOtherElectronics > 0) {
      UserSeller.typeList.add("OtherElectronics");
      UserSeller.typeOtherElectronics = typeOtherElectronics;
    }
    if (typeAirConditioner > 0) {
      UserSeller.typeList.add("AirConditioner");
      UserSeller.typeAirConditioner = typeAirConditioner;
    }
    if (typeOtherHome > 0) {
      UserSeller.typeList.add("OtherHome");
      UserSeller.typeOtherHome = typeOtherHome;
    }
    if (typeOtherPC > 0) {
      UserSeller.typeList.add("OtherPC");
      UserSeller.typeOtherPC = typeOtherPC;
    }
    if (typeFashion > 0) {
      UserSeller.typeList.add("Fashion");
      UserSeller.typeFashion = typeFashion;
    }
    if (typeStorageDevices > 0) {
      UserSeller.typeList.add("StorageDevices");
      UserSeller.typeStorageDevices = typeStorageDevices;
    }
    if (typeJewelry > 0) {
      UserSeller.typeList.add("Jewelry");
      UserSeller.typeJewelry = typeJewelry;
    }
    if (typeCameraAccessories > 0) {
      UserSeller.typeList.add("CameraAccessories");
      UserSeller.typeCameraAccessories = typeCameraAccessories;
    }
    if (typeCameras > 0) {
      UserSeller.typeList.add("Cameras");
      UserSeller.typeCameras = typeCameras;
    }
    if (typePrinters > 0) {
      UserSeller.typeList.add("Printers");
      UserSeller.typePrinters = typePrinters;
    }
    if (typeFridges > 0) {
      UserSeller.typeList.add("Fridges");
      UserSeller.typeFridges = typeFridges;
    }
    if (typeProjectors > 0) {
      UserSeller.typeList.add("Projectors");
      UserSeller.typeProjectors = typeProjectors;
    }
    if (typeTV > 0) {
      UserSeller.typeList.add("TV");
      UserSeller.typeTV = typeTV;
    }
  }
}

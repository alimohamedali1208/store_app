import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/UserCustomer.dart';
import 'package:store_app/UserSeller.dart';
import 'package:store_app/loggedinhome.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

enum SingingCharacter { Male, Female }

class _registerState extends State<register> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String fname, lname, phone, sex = 'M', email, pass, companyName, tax;
  UserCustomer cust = UserCustomer();
  UserSeller sell = UserSeller();
  bool flagTF = false;
  bool flagDB = false;
  bool showSpinner = false;
  SingingCharacter _character = SingingCharacter.Male;
  String dropdownValue = 'Customer';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
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
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'First Name:',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          fname = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Last Name:',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          lname = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone:',
                          hintText: '017775000',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          phone = value;
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
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'somone@something.com',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'you really need a hint for this?',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          pass = value;
                        },
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
                            flagTF = true;
                            flagDB = true;
                          } else if (dropdownValue == 'Customer') {
                            flagTF = false;
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
                        enabled: flagTF,
                        decoration: InputDecoration(
                          labelText: 'Company name:',
                          hintText: 'Sony',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          companyName = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        enabled: flagTF,
                        decoration: InputDecoration(
                          labelText: 'Tax Card:',
                          hintText: '15321',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          tax = value;
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
                } else {
                  _firestore.collection('Customers').add({
                    'FirstName': fname,
                    'LastName': lname,
                    'Phone': phone,
                    'Sex': sex,
                    'Email': email,
                    'Password': pass,
                  });
                }
                try {
                  final newuser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: pass);
                  if (newuser != null) {
                    //Did it change?
                    cust.firstName = fname;
                    Navigator.pushNamed(context, loggedinhome.id);
                  }
                  setState(() {
                    showSpinner = false;
                  });
                } catch (e) {
                  print(e);
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

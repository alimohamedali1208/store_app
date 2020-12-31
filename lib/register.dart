import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

enum SingingCharacter { Male, Female }

class _registerState extends State<register> {
  final _auth = FirebaseAuth.instance;
  String Fname;
  String Lname;
  String phone;
  String sex;
  String type;
  String email;
  String pass;
  SingingCharacter _character = SingingCharacter.Male;
  String dropdownValue = 'Customer';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("SignUp"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView(
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
                        Fname = value;
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
                        Lname = value;
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
                  ListTile(
                    title: const Text('Male'),
                    leading: Radio(
                      value: SingingCharacter.Male,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(
                          () {
                            _character = value;
                          },
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Female'),
                    leading: Radio(
                      value: SingingCharacter.Female,
                      groupValue: _character,
                      onChanged: (SingingCharacter value) {
                        setState(
                          () {
                            _character = value;
                          },
                        );
                      },
                    ),
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
                      });
                    },
                    items: <String>['Customer', 'Seller']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
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
              color: Colors.blueGrey[900],
              onPressed: () async {
                try {
                  final newuser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: pass);
                  // if (newuser != null) {
                  //   Navigator.push(context, );
                  // }
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

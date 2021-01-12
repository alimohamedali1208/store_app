import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/loggedinhome.dart';
import 'package:store_app/register.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _auth = FirebaseAuth.instance;
  String dropdownValue = 'Customer';
  bool flagDB = false;
  String email;
  String pass;
  bool showSpinner = false;
  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Form(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(Icons.email),
                          hintText: 'somone@something.com',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          icon: Icon(Icons.vpn_key_sharp),
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
                            flagDB = true;
                          } else if (dropdownValue == 'Customer') {
                            flagDB = true;
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
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        color: Colors.blueGrey[900],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => register()));
                        },
                        child: Text(
                          'New user?, Sign up here',
                          style: TextStyle(color: Colors.white),
                        ),
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
                try {
                  final newuser = await _auth.signInWithEmailAndPassword(
                      email: email, password: pass);
                  if (newuser != null) {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                } catch (e) {
                  print(e);
                  //showSpinner = false;
                  // Scaffold.of(context).showSnackBar(snackBar);
                }
                Navigator.pushNamed(context, loggedinhome.id);
              },
              child: Text(
                'Sign in',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

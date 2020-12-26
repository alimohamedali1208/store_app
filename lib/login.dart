import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _formKey = GlobalKey<FormState>();

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _auth = FirebaseAuth.instance;
  String email;
  String pass;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
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
                    padding: const EdgeInsets.all(20.0),
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
                } catch (e) {
                  print(e);
                }
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

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email;
  final _resetPasswordFormKey = GlobalKey<FormState>();
  bool validate = false;

  //toggling auto validate
  void _toggleValidate() {
    setState(() {
      validate = !validate;
    });
  }

  void sendButtonOnPressed() {
    if (_resetPasswordFormKey.currentState.validate()) {
      _resetPasswordFormKey.currentState.save();
    } else {
      _toggleValidate();
    }
  }

  String validateEmail(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return "please provide an email";
    } else if (!EmailValidator.validate(value, false, false)) {
      return "Please enter a valid email";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF731800),
        title: Text("Reset Password"),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        )),
      ),
      body: Form(
        key: _resetPasswordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  email = value.trim();
                },
              ),
            ),
            SizedBox(
              height: 10,
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
                  sendButtonOnPressed();
                },
                child: Text(
                  'Send Email',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

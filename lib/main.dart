import 'package:flutter/material.dart';
import 'package:store_app/loggedinhome.dart';
import 'package:store_app/login.dart';
import 'package:store_app/register.dart';
import 'package:store_app/sellerhome.dart';
import 'Home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: Home.id,
    routes: {
      Home.id: (context) => Home(),
      loggedinhome.id: (context) => loggedinhome(),
      sellerhome.id: (context) => sellerhome(),
      'login': (context) => login(),
      'register': (context) => register(),
    },
  ));
}

import 'package:flutter/material.dart';
import 'package:store_app/loggedinhome.dart';
import 'package:store_app/login.dart';
import 'package:store_app/register.dart';
import 'Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';



// final FirebaseApp app= FirebaseApp(
//   options: FirebaseOptions(
//     googleAppID:'1:36642527988:android:869a65a57e02172c28dca1',
//     apiKey: 'AIzaSyBykjyIdbKjOyEzVpOEHFVc_s3kQaIki5A',
//     databaseURL: 'https://store-cc25c-default-rtdb.firebaseio.com',
//   )
// );

//dd
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: Home.id,
    routes: {
      Home.id: (context) => Home(),
      loggedinhome.id: (context) => loggedinhome(),
      'login': (context) => login(),
      'register': (context) => register(),
    },
  ));
}

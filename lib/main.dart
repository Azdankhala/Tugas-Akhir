import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/Screen/loginScreen.dart';
import 'package:rider_app/Screen/mainscreen.dart';
import 'package:rider_app/Screen/registerScreen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef= FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rider App',
      theme: ThemeData(
        fontFamily: "Brand Bold",
        primarySwatch: Colors.blue,
      ),
      initialRoute: MainScreen.idScreen,
        routes:
      {
        RegisterScreen.idScreen: (context) => RegisterScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => MainScreen(),
      },
        debugShowCheckedModeBanner: false,
    );
  }
}
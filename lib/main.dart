import 'package:cardio_flutter/features/auth/presentation/pages/home_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/menu_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/patient_sign_up_page.dart';
import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (BuildContext context) => LoginPage(),
        "/signUp": (BuildContext context) => SignUpPage(),
        "/homePage": (BuildContext context) => HomePage(),
        "/patientSignUp": (BuildContext context) => PatientSignUpPage(),
        "/menuPage": (BuildContext context) => MenuPage(),
      },
    );
  }
}

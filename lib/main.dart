import 'package:cardio_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/home_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/menu_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/patient_sign_up_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/professional_signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (BuildContext context) => LoginPage(),
        "/professionalSignUp": (BuildContext context) =>
            ProfessionalSignUpPage(),
        "/homePage": (BuildContext context) => HomePage(),
        "/patientSignUp": (BuildContext context) => PatientSignUpPage(),
        "/menuPage": (BuildContext context) => MenuPage(),
      },
    );
  }
}

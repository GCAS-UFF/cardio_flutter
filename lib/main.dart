import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/patient_sign_up_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/professional_signup_page.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/exercise_page.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/pages/home_professional_page.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'features/appointments/domain/entities/appointment.dart';
import 'features/appointments/presentation/pages/appointment_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/biometrics/presentation/pages/biometric_page.dart';
import 'features/liquids/presentation/pages/liquid_page.dart';
import 'features/manage_professional/presentation/bloc/manage_professional_bloc.dart';
import 'features/medications/presentation/pages/medication_page.dart';
import 'injection_container.dart' as di;
import 'package:flutter/rendering.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    Provider<Settings>(
      create: (_) => di.sl<Settings>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => di.sl<AuthBloc>(),
          ),
          BlocProvider<ManageProfessionalBloc>(
            create: (_) => di.sl<ManageProfessionalBloc>(),
          ),
          BlocProvider<GenericBloc<Liquid>>(
            create: (_) => di.sl<GenericBloc<Liquid>>(),
          ),
          BlocProvider<GenericBloc<Exercise>>(
            create: (_) => di.sl<GenericBloc<Exercise>>(),
          ),
          BlocProvider<GenericBloc<Biometric>>(
            create: (_) => di.sl<GenericBloc<Biometric>>(),
          ),
          BlocProvider<GenericBloc<Appointment>>(
            create: (_) => di.sl<GenericBloc<Appointment>>(),
          ),
          BlocProvider<GenericBloc<Medication>>(
            create: (_) => di.sl<GenericBloc<Medication>>(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;
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
        "/homeProfessionalPage": (BuildContext context) =>
            HomeProfessionalPage(),
        "/patientSignUp": (BuildContext context) => PatientSignUpPage(),
        "/exercisePage": (BuildContext context) => ExercisePage(),
        "/liquidPage": (BuildContext context) => LiquidPage(),
        "/biometricPage": (BuildContext context) => BiometricPage(),
        "/appointmentPage": (BuildContext context) => AppointmentPage(),
        "/medicationPage": (BuildContext context) => MedicationPage(),
      },
    );
  }
}

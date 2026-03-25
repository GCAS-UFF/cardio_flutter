import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart'; // 1. Import atualizado
import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/patient_sign_up_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/professional_signup_page.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/exercise_page.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/pages/home_professional_page.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'features/appointments/domain/entities/appointment.dart';
import 'features/appointments/presentation/pages/appointment_page.dart';
import 'features/biometrics/presentation/pages/biometric_page.dart';
import 'features/liquids/presentation/pages/liquid_page.dart';
import 'features/manage_professional/presentation/bloc/manage_professional_bloc.dart';
import 'features/medications/presentation/pages/medication_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  // 2. Garante a inicialização dos bindings antes de tudo
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();

  // Inicializa a injeção de dependências
  await di.init();

  // 3. Inicializa o Alarm Manager (Versão Plus)
  await AndroidAlarmManager.initialize();

  runApp(
    Provider<Settings>(
      create: (_) => di.sl<Settings>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
          BlocProvider<ManageProfessionalBloc>(create: (_) => di.sl<ManageProfessionalBloc>()),
          BlocProvider<ExerciseBloc>(create: (_) => di.sl<ExerciseBloc>()),
          BlocProvider<GenericBloc<Liquid>>(create: (_) => di.sl<GenericBloc<Liquid>>()),
          BlocProvider<GenericBloc<Biometric>>(create: (_) => di.sl<GenericBloc<Biometric>>()),
          BlocProvider<GenericBloc<Appointment>>(create: (_) => di.sl<GenericBloc<Appointment>>()),
          BlocProvider<GenericBloc<Medication>>(create: (_) => di.sl<GenericBloc<Medication>>()),
        ],
        child: MyApp(),
      ),
    ),
  );

  // Exemplo de como usar o ID para sumir o erro de "unussed variable"
  // const int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(const Duration(minutes: 15), helloAlarmID, updateFirebase);
}

// 4. Função de Isolate (deve ser estática ou top-level)
@pragma('vm:entry-point') // Recomendado para o Alarm Manager no Dart moderno
void updateFirebase() async {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  WidgetsFlutterBinding.ensureInitialized();
  await di.initExternal();
  await di.initNotificationsForced();
  print("[$now] Hello, world! isolate=$isolateId function='updateFirebase'");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // 5. Adicionado const e super.key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cardio Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Opcional: Ativa o Material 3 se quiser o visual novo
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        "/professionalSignUp": (context) => ProfessionalSignUpPage(),
        "/homeProfessionalPage": (context) => HomeProfessionalPage(),
        "/patientSignUp": (context) => PatientSignUpPage(),
        "/exercisePage": (context) => ExercisePage(),
        "/liquidPage": (context) => LiquidPage(),
        "/biometricPage": (context) => BiometricPage(),
        "/appointmentPage": (context) => AppointmentPage(),
        "/medicationPage": (context) => MedicationPage(),
      },
    );
  }
}
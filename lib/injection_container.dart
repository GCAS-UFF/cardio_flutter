import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cardio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/get_current_user.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/sign_in.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_patient.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_professional.dart';
import 'package:cardio_flutter/features/biometrics/data/models/biometric_model.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/generic_feature/data/repositories/generic_repository_impl.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/add_recomendation.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/delete.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/edit_recomendation.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/execute.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/features/liquids/data/models/liquid_model.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/features/manage_professional/data/datasources/manage_professional_remote_data_source.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/delete_patient_list.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/edit_patient.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/edit_professional.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/get_patient_list.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/get_professional.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/bloc/manage_professional_bloc.dart';
import 'package:cardio_flutter/features/medications/data/models/medication_model.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:cardio_flutter/features/notitications/external_notification_manager.dart';
import 'package:cardio_flutter/features/notitications/notification_manager.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/platform/network_info.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/exercises/data/models/exercise_model.dart';
import 'features/generic_feature/data/datasources/generic_remote_data_source.dart';
import 'features/generic_feature/domain/repositories/generic_repository.dart';
import 'features/generic_feature/domain/usecases/edit_executed.dart';
import 'features/generic_feature/domain/usecases/get_list.dart';
import 'features/manage_professional/data/repositories/manage_professional_repository_impl.dart';
import 'features/manage_professional/domain/repositories/manage_professional_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.allowReassignment = true;

  _initAuth();
  _initManageProfessional();
  _initExercise();
  _initLiquid();
  _initBiometrics();
  _initAppointments();
  _initMedication();
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  await initExternal();

  //! Notifications
  initNotifications();
}

Future<void> initExternal() async {
  SharedPreferences.setMockInitialValues({});
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.allowReassignment = true;
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseDatabase.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseMessaging());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => Settings(sharedPreferences: sl()));
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
}

void initNotifications() {
  final notificationManager = NotificationManager(
      firebaseDatabase: sl(), localNotificationsPlugin: sl(), settings: sl());

  notificationManager.init();
  sl.registerLazySingleton(() => notificationManager);

  final externalNotificationManager =
      ExternalNotificationManager(firebaseMessaging: sl());

  externalNotificationManager.init();
  sl.registerLazySingleton(() => externalNotificationManager);
}

Future<void> initNotificationsForced() async {
  final NotificationManager notificationManager = NotificationManager(
      firebaseDatabase: sl(), localNotificationsPlugin: sl(), settings: sl());

  await notificationManager.init();
  sl.registerLazySingleton(() => notificationManager);
}

void _initAuth() {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUpPatient: sl(),
      signUpProfessional: sl(),
      getCurrentUser: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignUpProfessional(sl()));
  sl.registerLazySingleton(() => SignUpPatient(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      localDataSource: sl(),
      notificationManager: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firebaseDatabase: sl(),
    ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
}

void _initManageProfessional() {
  // Bloc
  sl.registerFactory(
    () => ManageProfessionalBloc(
      editPatientFromList: sl(),
      deletePatientFromList: sl(),
      getPatientList: sl(),
      editProfessional: sl(),
      getProfessional: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => EditPatientFromList(sl()));
  sl.registerLazySingleton(() => DeletePatientFromList(sl()));
  sl.registerLazySingleton(() => GetPatientList(sl()));
  sl.registerLazySingleton(() => EditProfessional(sl()));
  sl.registerLazySingleton(() => GetProfessional(sl()));

  // Repositories
  sl.registerLazySingleton<ManageProfessionalRepository>(
    () => ManageProfessionalRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ManageProfessionalRemoteDataSource>(
    () => ManageProfessionalRemoteDataSourceImpl(
      firebaseDatabase: sl(),
      firebaseAuth: sl(),
    ),
  );
}

void _initExercise() {
 // Bloc
  sl.registerFactory(
    () => GenericBloc<Exercise>(
      addRecomendation: sl(),
      editRecomendation: sl(),
      delete: sl(),
      getList: sl(),
      execute: sl(),
      editExecuted: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddRecomendation<Exercise>(sl()));
  sl.registerLazySingleton(() => EditRecomendation<Exercise>(sl()));
  sl.registerLazySingleton(() => Delete<Exercise>(sl()));
  sl.registerLazySingleton(() => GetList<Exercise>(sl()));
  sl.registerLazySingleton(() => Execute<Exercise>(sl()));
  sl.registerLazySingleton(() => EditExecuted<Exercise>(sl()));

  // Repositories
  sl.registerLazySingleton<GenericRepository<Exercise>>(
    () => GenericRepositoryImpl<Exercise, ExerciseModel>(
      type: "exercise",
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<GenericRemoteDataSource<ExerciseModel>>(
    () => GenericRemoteDataSourceImpl<ExerciseModel>(
      type: "exercise",
      firebaseDatabase: sl(),
      firebaseTag: "Exercise",
    ),
  );


}

void _initLiquid() {
  // Bloc
  sl.registerFactory(
    () => GenericBloc<Liquid>(
      addRecomendation: sl(),
      editRecomendation: sl(),
      delete: sl(),
      getList: sl(),
      execute: sl(),
      editExecuted: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddRecomendation<Liquid>(sl()));
  sl.registerLazySingleton(() => EditRecomendation<Liquid>(sl()));
  sl.registerLazySingleton(() => Delete<Liquid>(sl()));
  sl.registerLazySingleton(() => GetList<Liquid>(sl()));
  sl.registerLazySingleton(() => Execute<Liquid>(sl()));
  sl.registerLazySingleton(() => EditExecuted<Liquid>(sl()));

  // Repositories
  sl.registerLazySingleton<GenericRepository<Liquid>>(
    () => GenericRepositoryImpl<Liquid, LiquidModel>(
      type: "liquid",
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<GenericRemoteDataSource<LiquidModel>>(
    () => GenericRemoteDataSourceImpl<LiquidModel>(
      type: "liquid",
      firebaseDatabase: sl(),
      firebaseTag: "Liquid",
    ),
  );
}

void _initBiometrics() {
  // Bloc
  sl.registerFactory(
    () => GenericBloc<Biometric>(
      addRecomendation: sl(),
      editRecomendation: sl(),
      delete: sl(),
      getList: sl(),
      execute: sl(),
      editExecuted: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddRecomendation<Biometric>(sl()));
  sl.registerLazySingleton(() => EditRecomendation<Biometric>(sl()));
  sl.registerLazySingleton(() => Delete<Biometric>(sl()));
  sl.registerLazySingleton(() => GetList<Biometric>(sl()));
  sl.registerLazySingleton(() => Execute<Biometric>(sl()));
  sl.registerLazySingleton(() => EditExecuted<Biometric>(sl()));

  // Repositories
  sl.registerLazySingleton<GenericRepository<Biometric>>(
    () => GenericRepositoryImpl<Biometric, BiometricModel>(
      type: "biometric",
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<GenericRemoteDataSource<BiometricModel>>(
    () => GenericRemoteDataSourceImpl<BiometricModel>(
      type: "biometric",
      firebaseDatabase: sl(),
      firebaseTag: "Biometric",
    ),
  );
}

void _initAppointments() {
  // Bloc
  sl.registerFactory(
    () => GenericBloc<Appointment>(
      addRecomendation: sl(),
      editRecomendation: sl(),
      delete: sl(),
      getList: sl(),
      execute: sl(),
      editExecuted: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddRecomendation<Appointment>(sl()));
  sl.registerLazySingleton(() => EditRecomendation<Appointment>(sl()));
  sl.registerLazySingleton(() => Delete<Appointment>(sl()));
  sl.registerLazySingleton(() => GetList<Appointment>(sl()));
  sl.registerLazySingleton(() => Execute<Appointment>(sl()));
  sl.registerLazySingleton(() => EditExecuted<Appointment>(sl()));

  // Repositories
  sl.registerLazySingleton<GenericRepository<Appointment>>(
    () => GenericRepositoryImpl<Appointment, AppointmentModel>(
      type: "appointment",
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<GenericRemoteDataSource<AppointmentModel>>(
    () => GenericRemoteDataSourceImpl<AppointmentModel>(
      type: "appointment",
      firebaseDatabase: sl(),
      firebaseTag: "Appointment",
    ),
  );
}

void _initMedication() {
  // Bloc
  sl.registerFactory(
    () => GenericBloc<Medication>(
      addRecomendation: sl(),
      editRecomendation: sl(),
      delete: sl(),
      getList: sl(),
      execute: sl(),
      editExecuted: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddRecomendation<Medication>(sl()));
  sl.registerLazySingleton(() => EditRecomendation<Medication>(sl()));
  sl.registerLazySingleton(() => Delete<Medication>(sl()));
  sl.registerLazySingleton(() => GetList<Medication>(sl()));
  sl.registerLazySingleton(() => Execute<Medication>(sl()));
  sl.registerLazySingleton(() => EditExecuted<Medication>(sl()));

  // Repositories
  sl.registerLazySingleton<GenericRepository<Medication>>(
    () => GenericRepositoryImpl<Medication, MedicationModel>(
      type: "medication",
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<GenericRemoteDataSource<MedicationModel>>(
    () => GenericRemoteDataSourceImpl<MedicationModel>(
      type: "medication",
      firebaseDatabase: sl(),
      firebaseTag: "Medication",
    ),
  );
}

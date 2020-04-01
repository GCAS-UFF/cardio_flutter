import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cardio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/sign_in.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_patient.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_professional.dart';
import 'package:cardio_flutter/features/exercises/data/datasources/exercise_remote_data_source.dart';
import 'package:cardio_flutter/features/exercises/data/repository/exercise_repository_impl.dart';
import 'package:cardio_flutter/features/exercises/domain/usecases/add_exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/usecases/edit_exercise_professional.dart';
import 'package:cardio_flutter/features/exercises/domain/usecases/execute_exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/usecases/get_exercise_list.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart';
import 'package:cardio_flutter/features/generic_feature/data/repositories/generic_repository_impl.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/add_recomendation.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/delete.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/edit_recomendation.dart';
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
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/platform/network_info.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/exercises/domain/repository/exercise_repository.dart';
import 'features/exercises/domain/usecases/delete_exercise.dart';
import 'features/exercises/domain/usecases/edit_executed_exercise.dart';
import 'features/generic_feature/data/datasources/generic_remote_data_source.dart';
import 'features/generic_feature/domain/repositories/generic_repository.dart';
import 'features/generic_feature/domain/usecases/get_list.dart';
import 'features/manage_professional/data/repositories/manage_professional_repository_impl.dart';
import 'features/manage_professional/domain/repositories/manage_professional_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  initAuth();
  initManageProfessional();
  initExerxise();
  initLiquid();
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseDatabase.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => Settings(sharedPreferences: sl()));
}

void initAuth() {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUpPatient: sl(),
      signUpProfessional: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignUpProfessional(sl()));
  sl.registerLazySingleton(() => SignUpPatient(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      localDataSource: sl(),
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

void initManageProfessional() {
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

void initExerxise() {
  // Bloc
  sl.registerFactory(
    () => ExerciseBloc(
      deleteExercise: sl(),
      editExerciseProfessional: sl(),
      addExercise: sl(),
      getExerciseList: sl(),
      executeExercise: sl(),
      editExecutedExercise: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => ExecuteExercise(sl()));
  sl.registerLazySingleton(() => EditExecutedExercise(sl()));
  sl.registerLazySingleton(() => AddExercise(sl()));
  sl.registerLazySingleton(() => DeleteExercise(sl()));
  sl.registerLazySingleton(() => GetExerciseList(sl()));
  sl.registerLazySingleton(() => EditExerciseProfessional(sl()));

  // Repositories
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ExerciseRemoteDataSource>(
    () => ExerciseRemoteDataSourceImpl(
      firebaseDatabase: sl(),
    ),
  );
}

void initLiquid() {
  // Bloc
  sl.registerFactory(
    () => GenericBloc<Liquid>(
      addRecomendation: sl(),
      editRecomendation: sl(),
      delete: sl(),
      getList: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddRecomendation<Liquid>(sl()));
  sl.registerLazySingleton(() => EditRecomendation<Liquid>(sl()));
  sl.registerLazySingleton(() => Delete<Liquid>(sl()));
  sl.registerLazySingleton(() => GetList<Liquid>(sl()));

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

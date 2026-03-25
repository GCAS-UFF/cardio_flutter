import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/platform/network_info.dart';
import 'package:cardio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:cardio_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/data/models/professional_model.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:cardio_flutter/features/notitications/notification_manager.dart'; // Verifique se corrigiu a pasta para 'notifications'
import 'package:cardio_flutter/resources/keys.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final NotificationManager notificationManager;

  // 1. Uso do 'required' nativo e remoção do meta.dart
  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.notificationManager,
  });

  @override
  Future<Either<Failure, dynamic>> signIn(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final dynamic user = await remoteDataSource.signIn(email, password);
        
        String type;
        if (user is PatientModel) {
          type = Keys.PATIENT_TYPE;
        } else if (user is ProfessionalModel) {
          type = Keys.PROFESSIONAL_TYPE;
        } else {
          type = "UNDEFINED";
        }

        // 2. No Dart 3, se o remoteDataSource não retorna null (lança exceção), 
        // a checagem 'user != null' é redundante, mas mantemos o ID seguro.
        final String userId = user.id ?? ""; 
        await localDataSource.saveUserId(userId);
        await localDataSource.saveUserType(type);
        
        // Inicializa notificações após login bem sucedido
        notificationManager.init();

        return Right(user);
      } on PlatformException catch (e) {
        return Left(PlatformFailure(message: e.message ?? "Erro de plataforma"));
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Patient>> signUpPatient(
      Patient patient, String password) async {
    if (await networkInfo.isConnected) {
      try {
        // 3. getUserId agora retorna String?, então tratamos o nulo
        final String? userId = await localDataSource.getUserId();
        final String? userType = await localDataSource.getUserType();

        if (userId == null || userType == null || userType == Keys.PATIENT_TYPE) {
          return Left(ServerFailure());
        }

        // 4. Tratamos o PatientModel.fromEntity que agora pode ser opcional
        final patientModel = PatientModel.fromEntity(patient);
        if (patientModel == null) return Left(ServerFailure());

        final Patient result = await remoteDataSource.signUpPatient(
            userId, patientModel, password);

        return Right(result);
      } on PlatformException catch (e) {
        return Left(PlatformFailure(message: e.message ?? "Erro de plataforma"));
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Professional>> signUpProfessional(
      Professional professional, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final profModel = ProfessionalModel.fromEntity(professional);
        if (profModel == null) return Left(ServerFailure());

        final Professional result = await remoteDataSource.signUpProfessional(
            profModel, password);
        
        // 5. Garantimos que o ID não seja nulo ao salvar no cache
        await localDataSource.saveUserId(result.id ?? "");
        await localDataSource.saveUserType(Keys.PROFESSIONAL_TYPE);
        
        return Right(result);
      } on PlatformException catch (e) {
        return Left(PlatformFailure(message: e.message ?? "Erro de plataforma"));
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, dynamic>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final dynamic user = await remoteDataSource.getCurrentUser();
        
        String type;
        if (user is PatientModel) {
          type = Keys.PATIENT_TYPE;
        } else if (user is ProfessionalModel) {
          type = Keys.PROFESSIONAL_TYPE;
        } else {
          type = "UNDEFINED";
        }

        await localDataSource.saveUserId(user.id ?? "");
        await localDataSource.saveUserType(type);
        return Right(user);
      } on PlatformException catch (e) {
        return Left(PlatformFailure(message: e.message ?? "Erro de plataforma"));
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      } on UserNotCachedException {
        return Left(UserNotCachedFailure());
      }
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }
}
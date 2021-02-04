import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/platform/network_info.dart';
import 'package:cardio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:cardio_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/data/models/profissional_model.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:cardio_flutter/features/notitications/notification_manager.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final NotificationManager notificationManager;

  AuthRepositoryImpl(
      {@required this.localDataSource,
      @required this.remoteDataSource,
      @required this.networkInfo,
      @required this.notificationManager});

  @override
  Future<Either<Failure, dynamic>> signIn(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        dynamic user = await remoteDataSource.signIn(email, password);
        String type;
        if (user is PatientModel) {
          type = Keys.PATIENT_TYPE;
        } else if (user is ProfessionalModel) {
          type = Keys.PROFESSIONAL_TYPE;
        } else {
          type = "UNDEFINED";
        }

        if (user != null) {
          await localDataSource.saveUserId(user.id);
          await localDataSource.saveUserType(type);

          notificationManager.init();

          return Right(user);
        } else {
          return Left(ServerFailure());
        }
      } on PlatformException catch (e) {
        return Left(PlatformFailure(message: e.message));
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
        String userId = await localDataSource.getUserId();
        String userType = await localDataSource.getUserType();

        if (userId == null || userType == null || userType == Keys.PATIENT_TYPE)
          return Left(ServerFailure());

        Patient result = await remoteDataSource.signUpPatient(
            userId, PatientModel.fromEntity(patient), password);

        return Right(result);
      } on PlatformException catch (e) {
        return Left(PlatformFailure(message: e.message));
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
        Professional result = await remoteDataSource.signUpProfessional(
            ProfessionalModel.fromEntity(professional), password);
        if (professional != null) {
          await localDataSource.saveUserId(professional.id);
          await localDataSource.saveUserType(Keys.PROFESSIONAL_TYPE);
          return Right(result);
        } else {
          return Left(ServerFailure());
        }
      } on PlatformException catch (e) {
        return Left(PlatformFailure(message: e.message));
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
        dynamic user = await remoteDataSource.getCurrentUser();
        String type;
        if (user is PatientModel) {
          type = Keys.PATIENT_TYPE;
        } else if (user is ProfessionalModel) {
          type = Keys.PROFESSIONAL_TYPE;
        } else {
          type = "UNDEFINED";
        }

        if (user != null) {
          await localDataSource.saveUserId(user.id);
          await localDataSource.saveUserType(type);

          notificationManager.init();

          return Right(user);
        } else {
          return Left(ServerFailure());
        }
      } on PlatformException catch (e) {
        return Left(PlatformFailure(message: e.message));
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

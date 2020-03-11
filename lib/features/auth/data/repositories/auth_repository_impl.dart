import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/platform/network_info.dart';
import 'package:cardio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:cardio_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/data/models/profissional_model.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/domain/entities/user.dart';
import 'package:cardio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {@required this.localDataSource,
      @required this.remoteDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        User user = await remoteDataSource.signIn(email, password);
        if (user != null) {
          await localDataSource.saveUserId(user.id);
          await localDataSource.saveUserType(user.type);
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

        Patient patientResult = await remoteDataSource.signUpPatient(
            userId, PatientModel.fromEntity(patient), password);
            
        return Right(patientResult);
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
        Professional professionalResult =
            await remoteDataSource.signUpProfessional(
                ProfessionalModel.fromEntity(professional), password);
        if (professional != null) {
          await localDataSource.saveUserId(professional.id);
          await localDataSource.saveUserType(Keys.PROFESSIONAL_TYPE);
          return Right(professionalResult);
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
}

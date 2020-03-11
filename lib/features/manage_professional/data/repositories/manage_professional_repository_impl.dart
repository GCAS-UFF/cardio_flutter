import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/platform/network_info.dart';
import 'package:cardio_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/data/models/profissional_model.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/manage_professional/data/datasources/manage_professional_remote_data_source.dart';
import 'package:cardio_flutter/features/manage_professional/domain/repositories/manage_professional_repository.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class ManageProfessionalRepositoryImpl implements ManageProfessionalRepository {
  final ManageProfessionalRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ManageProfessionalRepositoryImpl(
      {@required this.localDataSource,
      @required this.remoteDataSource,
      @required this.networkInfo});
  @override
  Future<Either<Failure, void>> deletePatientList(Patient patient) async {
    if (await networkInfo.isConnected) {
      try {
        String userId = await localDataSource.getUserId();
        String userType = await localDataSource.getUserType();

        if (userId == null ||
            userType == null ||
            userType != Keys.PROFESSIONAL_TYPE) return Left(ServerFailure());

        return Right(await remoteDataSource.deletePatient(
            userId, PatientModel.fromEntity(patient)));
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
  Future<Either<Failure, Patient>> editPatientList(Patient patient) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource
            .editPatient(PatientModel.fromEntity(patient)));
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
  Future<Either<Failure, Professional>> editProfessional(
      Professional professional) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource
            .editProfessional(ProfessionalModel.fromEntity(professional)));
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
  Future<Either<Failure, List<Patient>>> getPatientList() async {
    if (await networkInfo.isConnected) {
      try {
        String userId = await localDataSource.getUserId();
        String userType = await localDataSource.getUserType();

        if (userId == null ||
            userType == null ||
            userType != Keys.PROFESSIONAL_TYPE) return Left(ServerFailure());

        return Right(await remoteDataSource.getPatientList(userId));
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

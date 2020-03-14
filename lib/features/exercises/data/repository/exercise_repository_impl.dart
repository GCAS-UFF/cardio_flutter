import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/platform/network_info.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/exercises/data/datasources/exercise_remote_data_source.dart';
import 'package:cardio_flutter/features/exercises/data/models/exercise_model.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/repository/exercise_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final NetworkInfo networkInfo;
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Exercise>> addExercise(
      Patient patient, Exercise exercise) async {
    try {
      return Right(await remoteDataSource.addExercise(
          PatientModel.fromEntity(patient),
          ExerciseModel.fromEntity(exercise)));
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Exercise>> editExerciseProfessional(
      Exercise exercise, Patient patient) async {
    try {
      return Right(await remoteDataSource.editExerciseProfessional(
        ExerciseModel.fromEntity(exercise),
        PatientModel.fromEntity(patient),
      ));
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Exercise>> executeExercise(
      Exercise exercise, Patient patient) async {
    try {
      return Right(await remoteDataSource.executeExercise(
        ExerciseModel.fromEntity(exercise),
        PatientModel.fromEntity(patient),
      ));
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> getExerciseList(
      Patient patient) async {
    try {
      return Right(await remoteDataSource.getExerciseList(
        PatientModel.fromEntity(patient),
      ));
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

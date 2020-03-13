import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/platform/network_info.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/exercises/data/datasources/exercise_remote_data_source.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/repository/exercise_repository.dart';
import 'package:dartz/dartz.dart';

class ExerciseRepositoryImpl implements ExerciseRepository{
NetworkInfo networkInfo;
ExerciseRemoteDataSource remoteDataSource;






  @override
  Future<Either<Failure, Exercise>> addExercise(Patient patient, Exercise exercise) {
    // TODO: implement addExercise
    return null;
  }

  @override
  Future<Either<Failure, Exercise>> editExerciseProfessional(Exercise exercise, Patient patient) {
    // TODO: implement editExerciseProfessional
    return null;
  }

  @override
  Future<Either<Failure, Exercise>> executeExercise(Exercise exercise, Patient patient) {
    // TODO: implement executeExercise
    return null;
  }

  @override
  Future<Either<Failure, List<Exercise>>> getExerciseList(Patient patient) {
    // TODO: implement getExerciseList
    return null;
  }


}
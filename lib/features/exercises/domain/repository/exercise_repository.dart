import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:dartz/dartz.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, Exercise>> addExercise(Patient patient);
  Future<Either<Failure, Exercise>> editExerciseProfessional(String exerciseId);
  Future<Either<Failure, List<Exercise>>> checkExercise(Patient patient);
  Future<Either<Failure, Exercise>> executeExercise(String exerciseId);
}

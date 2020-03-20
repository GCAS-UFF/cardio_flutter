import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';

import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:dartz/dartz.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, Exercise>> addExercise(Patient patient, Exercise exercise);
  Future<Either<Failure, void>> deleteExercise(Patient patient, Exercise exercise);
  Future<Either<Failure, Exercise>> editExerciseProfessional(Exercise exercise, Patient patient);
  Future<Either<Failure, List<Exercise>>> getExerciseList(Patient patient);
  Future<Either<Failure, Exercise>> executeExercise(Exercise exercise, Patient patient);
  Future<Either<Failure, Exercise>> editExecutedExercise(Exercise exercise, Patient patient);
}

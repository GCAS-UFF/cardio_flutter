import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/repository/exercise_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AddExercise extends UseCase<Exercise, Params> {
  final ExerciseRepository repository;

  AddExercise(this.repository);
  @override
  Future<Either<Failure, Exercise>> call(Params params) async {

    return await repository.addExercise(params.patient, params.exercise);
  }
}

class Params extends Equatable {
  final Patient patient; 
  final Exercise exercise;

  Params({@required this.patient, @required this.exercise}) : super();

  @override
  
  List<Object> get props => [patient, exercise];
}

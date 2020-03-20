import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/repository/exercise_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class DeleteExercise extends UseCase<void, Params> {
  final ExerciseRepository repository;

  DeleteExercise(this.repository);
  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.deleteExercise( params.patient,params.exercise,);
  }
}

class Params extends Equatable {
  final Exercise exercise;
  final Patient patient;

  Params({@required this.exercise, @required this.patient}) : super();

  @override
  List<Object> get props => [exercise, patient];
}

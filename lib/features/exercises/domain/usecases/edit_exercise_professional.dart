
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/repository/exercise_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class EditExerciseProfessional extends UseCase<Exercise, Params > {
  final ExerciseRepository repository;

  EditExerciseProfessional(this.repository);
  @override

  Future<Either<Failure, Exercise>> call(Params params) async {

    return await repository.editExerciseProfessional(params.exerciseId);
  }
}
class Params extends Equatable {
  final String exerciseId; 

  Params({@required this.exerciseId}) : super();

  @override
  
  List<Object> get props => [exerciseId];
}
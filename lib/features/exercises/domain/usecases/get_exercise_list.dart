import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/repository/exercise_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GetExerciseList extends UseCase<List<Exercise>, Params> {
  final ExerciseRepository repository;

  GetExerciseList(this.repository);
  @override
  Future<Either<Failure, List<Exercise>>> call(Params params) async {
    return await repository.getExerciseList(params.patient);
  }
}

class Params extends Equatable {
  final Patient patient;

  Params({@required this.patient}) : super();

  @override
  List<Object> get props => [patient];
}

import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/generic_feature/domain/repositories/generic_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AddRecomendation<Entity> extends UseCase<Entity, Params> {
  final GenericRepository<Entity> repository;

  AddRecomendation(this.repository);

  @override
  Future<Either<Failure, Entity>> call(Params params) async {
    return await repository.addRecomendation(params.patient, params.entity);
  }
}

class Params<Entity> extends Equatable {
  final Patient patient;
  final Entity entity;

  Params({@required this.patient, @required this.entity}) : super();

  @override
  List<Object> get props => [patient, entity];
}
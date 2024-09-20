import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:cardio_flutter/features/generic_feature/domain/repositories/generic_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class EditExecuted<Entity extends BaseEntity> extends UseCase<Entity, Params> {
  final GenericRepository<Entity> repository;

  EditExecuted(this.repository);

  @override
  Future<Either<Failure, Entity>> call(Params params) async {
    return await repository.editExecuted(params.patient, params.entity);
  }
}

class Params<Entity> extends Equatable {
  final Patient patient;
  final Entity entity;

  Params({@required this.patient, @required this.entity}) : super();

  @override
  List<Object> get props => [patient, entity];
}
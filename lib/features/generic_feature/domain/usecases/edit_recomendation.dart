import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:cardio_flutter/features/generic_feature/domain/repositories/generic_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class EditRecomendation<Entity extends BaseEntity>
    extends UseCase<Entity, Params> {
  final GenericRepository<Entity> repository;

  EditRecomendation(this.repository);

  @override
  Future<Either<Failure, Entity>> call(Params params) async {
    return await repository.editRecomendation(params.patient, params.entity);
  }
}

class Params<Entity> extends Equatable {
  final Entity entity;
  final Patient patient;

  Params({@required this.entity, @required this.patient});

  @override
  List<Object> get props => [entity, patient];
}

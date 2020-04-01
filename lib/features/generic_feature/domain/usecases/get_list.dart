import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:cardio_flutter/features/generic_feature/domain/repositories/generic_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GetList<Entity extends BaseEntity> extends UseCase<List<Entity>, Params> {
  final GenericRepository<Entity> repository;

  GetList(this.repository);

  @override
  Future<Either<Failure, List<Entity>>> call(Params params) async {
    return await repository.getList(params.patient);
  }
}

class Params extends Equatable {
  final Patient patient;

  Params({@required this.patient}) : super();

  @override
  List<Object> get props => [patient];
}

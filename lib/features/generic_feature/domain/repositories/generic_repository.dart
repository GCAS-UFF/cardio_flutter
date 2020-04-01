import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:dartz/dartz.dart';

abstract class GenericRepository<Entity extends BaseEntity> {
  Future<Either<Failure, Entity>> addRecomendation(
      Patient patient, Entity entitiy);
  Future<Either<Failure, Entity>> editRecomendation(
      Patient patient, Entity entitiy);
  Future<Either<Failure, List<Entity>>> getList(Patient patient);
  Future<Either<Failure, void>> delete(Patient patient, Entity entity);
}

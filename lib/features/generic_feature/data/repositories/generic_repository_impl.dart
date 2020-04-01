import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/platform/network_info.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/generic_feature/data/datasources/generic_remote_data_source.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:cardio_flutter/features/generic_feature/domain/repositories/generic_repository.dart';
import 'package:cardio_flutter/features/generic_feature/util/generic_converter.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

class GenericRepositoryImpl<Entity extends BaseEntity, Model extends Entity>
    extends GenericRepository<Entity> {
  final NetworkInfo networkInfo;
  final GenericRemoteDataSource<Model> remoteDataSource;
  final String type;

  GenericRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource,
    @required this.type,
  });

  @override
  Future<Either<Failure, Entity>> addRecomendation(
      Patient patient, Entity recomendation) async {
    try {
      return Right(
        await remoteDataSource.addRecomendation(
          PatientModel.fromEntity(patient),
          GenericConverter.genericModelFromEntity<Entity, Model>(
              type, recomendation),
        ),
      );
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Entity>>> getList(Patient patient) async {
    try {
      return Right(await remoteDataSource.getList(
        PatientModel.fromEntity(patient),
      ));
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Entity>> editRecomendation(
      Patient patient, Entity recomendation) async {
    try {
      return Right(await remoteDataSource.editRecomendation(
        PatientModel.fromEntity(patient),
        GenericConverter.genericModelFromEntity<Entity, Model>(
            type, recomendation),
        recomendation.id,
      ));
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(Patient patient, Entity entity) async {
    try {
      return Right(await remoteDataSource.delete(
          PatientModel.fromEntity(patient), entity.done, entity.id));
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Entity>> editExecuted(
      Patient patient, Entity entity) async {
    try {
      return Right(await remoteDataSource.editExecuted(
        PatientModel.fromEntity(patient),
        GenericConverter.genericModelFromEntity<Entity, Model>(type, entity),
        entity.id,
      ));
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Entity>> execute(
      Patient patient, Entity entity) async {
    try {
      return Right(await remoteDataSource.execute(
        PatientModel.fromEntity(patient),
        GenericConverter.genericModelFromEntity<Entity, Model>(type, entity),
      ));
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/platform/network_info.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/generic_feature/data/datasources/generic_remote_data_source.dart';
import 'package:cardio_flutter/features/generic_feature/domain/repositories/generic_repository.dart';
import 'package:cardio_flutter/features/generic_feature/util/generic_converter.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

class GenericRepositoryImpl<Entity, Model extends Entity>
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
          GenericConverter.genericModelFromEntity<Entity, Model>(type, recomendation),
        ),
      );
    } on PlatformException catch (e) {
      return Left(PlatformFailure(message: e.message));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

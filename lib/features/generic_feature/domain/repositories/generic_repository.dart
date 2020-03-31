import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:dartz/dartz.dart';

abstract class GenericRepository <Entity>{
  Future<Either<Failure, Entity>> addRecomendation(Patient patient, Entity exercise);
}
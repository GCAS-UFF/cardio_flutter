import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, dynamic>> signIn(String email, String password);

  Future<Either<Failure, Patient>> signUpPatient(
      Patient patient, String password);

  Future<Either<Failure, Professional>> signUpProfessional(
      Professional professional, String password);
}

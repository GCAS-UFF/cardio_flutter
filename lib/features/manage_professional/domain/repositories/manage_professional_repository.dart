import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/domain/entities/user.dart';

import 'package:dartz/dartz.dart';

abstract class ManageProfessionalRepository {
  Future<Either<Failure, List<Patient>>> getPatientList();
  Future<Either<Failure, void>> deletePatientList(Patient patient);
  Future<Either<Failure, Patient>> editPatientList(Patient patient);
  Future<Either<Failure, Professional>> editProfessional(
      Professional professional);
  Future<Either<Failure, Professional>> getProfessional(
      User user);
}

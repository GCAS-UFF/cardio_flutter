import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';

import 'package:dartz/dartz.dart';

abstract class PatientListRepository {
  Future<Either<Failure, List<Patient>>> getPatientList();
  Future<Either<Failure, Patient>> deletePatientList(Patient patient);
  Future<Either<Failure, Patient>> addPatientList(Patient patient);
  Future<Either<Failure, Patient>> editPatientList(Patient patient);
  }

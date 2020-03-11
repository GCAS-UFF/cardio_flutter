import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/manage_professional/domain/repositories/manage_professional_repository.dart';
import 'package:dartz/dartz.dart';

class ManageProfessionalRepositoryImpl implements ManageProfessionalRepository {
  @override
  Future<Either<Failure, void>> deletePatientList(Patient patient) {
    // TODO: implement deletePatientList
    return null;
  }

  @override
  Future<Either<Failure, Patient>> editPatientList(Patient patient) {
    // TODO: implement editPatientList
    return null;
  }

  @override
  Future<Either<Failure, Professional>> editProfessional(
      Professional professional) {
    // TODO: implement editProfessional
    return null;
  }

  @override
  Future<Either<Failure, List<Patient>>> getPatientList() {
    // TODO: implement getPatientList
    return null;
  }
}

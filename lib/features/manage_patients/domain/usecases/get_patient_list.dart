import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';

import 'package:cardio_flutter/features/manage_patients/domain/repositories/manage_patient_repository.dart';
import 'package:dartz/dartz.dart';



class GetPatientList extends UseCase<List<Patient>, NoParams> {
  final PatientListRepository repository;

  GetPatientList(this.repository);



   @override
  Future<Either<Failure, List<Patient>>> call(NoParams params) async {
    return await repository.getPatientList();
  }
}


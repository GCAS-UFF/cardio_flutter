import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/manage_patients/domain/repositories/manage_patient_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AddPatientToList extends UseCase<Patient, Params> {
  final PatientListRepository repository;

  AddPatientToList(this.repository);

  @override
  Future<Either<Failure, Patient>> call(Params params) async {
    return await repository.addPatientList(params.patient);
  }
}

class Params extends Equatable {
  final Patient patient;

  Params({@required this.patient}) : super();

  @override
  List<Object> get props => [patient];
}

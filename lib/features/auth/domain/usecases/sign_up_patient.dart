import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SignUpPatient implements UseCase<Patient, Params> {
  final AuthRepository repository;

  SignUpPatient(this.repository);

  @override
  Future<Either<Failure, Patient>> call(Params params) {
    // The patient password is by default his cpf
    return repository.signUpPatient(params.patient, params.patient.cpf.replaceAll("-", "").replaceAll(".", ""));
  }
}

class Params extends Equatable {
  final Patient patient;

  Params({@required this.patient});

  @override
  List<Object> get props => [patient];
}

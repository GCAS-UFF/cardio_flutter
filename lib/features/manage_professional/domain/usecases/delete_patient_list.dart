import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/manage_professional/domain/repositories/manage_professional_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class DeletePatientFromList extends UseCase<void, Params> {
  final ManageProfessionalRepository repository;

  DeletePatientFromList(this.repository);
  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.deletePatientList(params.patient);
  }
}

class Params extends Equatable {
  final Patient patient;

  Params({@required this.patient}) : super();

  @override
  List<Object> get props => [patient];
}


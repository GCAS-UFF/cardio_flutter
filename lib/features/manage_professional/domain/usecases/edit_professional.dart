import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/manage_professional/domain/repositories/manage_professional_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class EditProfessional extends UseCase<Professional, Params>{
  final ManageProfessionalRepository repository;

  EditProfessional(this.repository);
   @override
  Future<Either<Failure, Professional>> call(Params params) async {
    return await repository.editProfessional(params.professional);
  }
}

class Params extends Equatable {
  final Professional professional;

  Params({@required this.professional});

  @override
  List<Object> get props => [professional];
}

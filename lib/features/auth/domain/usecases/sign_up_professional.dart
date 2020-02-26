import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SignUpProfessional implements UseCase<Professional, Params> {
  final AuthRepository repository;

  SignUpProfessional(this.repository);

  @override
  Future<Either<Failure, Professional>> call(Params params) {
    return repository.signUpProfessional(params.professional, params.password);
  }
}

class Params extends Equatable {
  final Professional professional;
  final String password;

  Params({@required this.professional, @required this.password});

  @override
  List<Object> get props => [professional, password];
}

import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SignIn implements UseCase<dynamic, Params> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(Params params) {
    return repository.signIn(params.email, params.password);
  }
}

class Params extends Equatable {
  final String email;
  final String password;

  Params({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}

import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/domain/entities/user.dart';
import 'package:cardio_flutter/features/manage_professional/domain/repositories/manage_professional_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class GetProfessional extends UseCase<Professional, Params>{
  final ManageProfessionalRepository repository;

  GetProfessional(this.repository);
  
   @override
  Future<Either<Failure, Professional>> call(Params params) async {
    return await repository.getProfessional(params.user);
  }
}

class Params extends Equatable {
  final User user;

  Params({@required this.user});

  @override
  List<Object> get props => [user];
}

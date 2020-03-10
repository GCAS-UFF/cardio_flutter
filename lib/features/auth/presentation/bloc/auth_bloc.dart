import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/domain/entities/user.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/sign_in.dart'
    as sign_in;
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_patient.dart'
    as sign_patient;
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_professional.dart'
    as sign_professional;
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../resources/keys.dart';
import '../../../../resources/strings.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final sign_in.SignIn signIn;
  final sign_patient.SignUpPatient signUpPatient;
  final sign_professional.SignUpProfessional signUpProfessional;

  AuthBloc(
      {@required this.signIn,
      @required this.signUpPatient,
      @required this.signUpProfessional})
      : assert(signIn != null),
        assert(signUpPatient != null),
        assert(signUpProfessional != null);

  @override
  AuthState get initialState => Empty();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignInEvent) {
      yield Loading();
      var userOrFailure = await signIn(
          sign_in.Params(email: event.email, password: event.password));
      yield* _eitherLoggedOrErrorState(userOrFailure);
    } else if (event is SignUpPatientEvent) {
      yield Loading();
      var userOrFailure =
          await signUpPatient(sign_patient.Params(patient: event.patient));
      yield* _eitherSignedUpOrErrorState(userOrFailure);
    } else if (event is SignUpProfessionalEvent) {
      yield Loading();
      var userOrFailure = await signUpProfessional(sign_professional.Params(
          professional: event.professional, password: event.password));
      yield* _eitherSignedUpOrErrorState(userOrFailure);
    }
  }

  Stream<AuthState> _eitherLoggedOrErrorState(
      Either<Failure, User> userOrFailure) async* {
    yield userOrFailure.fold((failure) {
      return Error(message: Converter.convertFailureToMessage(failure));
    }, (user) {
      if (user.type == Keys.PATIENT_TYPE){
      return LoggedPatient();
      } else if (user.type == Keys.PROFESSIONAL_TYPE) {
        return LoggedProfessional();
      } else {
        return Error(message: Strings.invalid_user_type);
      }
    });
  }

  Stream<AuthState> _eitherSignedUpOrErrorState(
      Either<Failure, dynamic> userOrFailure) async* {
    yield userOrFailure.fold((failure) {
      return Error(message: Converter.convertFailureToMessage(failure));
    }, (result) {
      return SignedUp();
    });
  }
}

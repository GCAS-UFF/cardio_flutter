import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/get_current_user.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/sign_in.dart' as sign_in;
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_patient.dart' as sign_patient;
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_professional.dart' as sign_professional;
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../resources/strings.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final sign_in.SignIn signIn;
  final sign_patient.SignUpPatient signUpPatient;
  final sign_professional.SignUpProfessional signUpProfessional;
  final GetCurrentUser getCurrentUser;

  AuthBloc({@required this.signIn, @required this.signUpPatient, @required this.signUpProfessional, @required this.getCurrentUser})
      : assert(signIn != null),
        assert(signUpPatient != null),
        assert(signUpProfessional != null),
        assert(getCurrentUser != null) {
    this.add(GetUserStatusEvent());
  }

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignInEvent) {
      yield Loading();
      var userOrFailure = await signIn(sign_in.Params(email: event.email, password: event.password));
      yield* _eitherLoggedOrErrorState(userOrFailure);
      _sendSignInEvent(userOrFailure);
    } else if (event is SignUpPatientEvent) {
      yield Loading();
      var userOrFailure = await signUpPatient(sign_patient.Params(patient: event.patient));
      yield* _eitherSignedUpOrErrorState(userOrFailure);
      _sendSignUpEvent(userOrFailure);
    } else if (event is SignUpProfessionalEvent) {
      yield Loading();
      var userOrFailure = await signUpProfessional(sign_professional.Params(professional: event.professional, password: event.password));
      yield* _eitherSignedUpOrErrorState(userOrFailure);
      _sendSignUpEvent(userOrFailure);
    } else if (event is GetUserStatusEvent) {
      var userOrFailure = await getCurrentUser(NoParams());
      yield* _eitherLoggedOrErrorState(userOrFailure);
    }
  }

  Stream<AuthState> _eitherLoggedOrErrorState(Either<Failure, dynamic> userOrFailure) async* {
    yield userOrFailure.fold((failure) {
      if (failure is UserNotCachedFailure) return Empty();
      return Error(message: Converter.convertFailureToMessage(failure));
    }, (user) {
      if (user is Patient) {
        return LoggedPatient(patient: user);
      } else if (user is Professional) {
        return LoggedProfessional(professional: user);
      } else {
        return Error(message: Strings.invalid_user_type);
      }
    });
  }

  Stream<AuthState> _eitherSignedUpOrErrorState(Either<Failure, dynamic> userOrFailure) async* {
    yield userOrFailure.fold((failure) {
      return Error(message: Converter.convertFailureToMessage(failure));
    }, (result) {
      return SignedUp(user: result);
    });
  }

  void _sendSignInEvent(dynamic userOrFailure) {
    var user = userOrFailure.getOrElse(() => null);
    _updateUserInMixpanel(userOrFailure);
    if (user is Patient) {
      Mixpanel.trackEvent(MixpanelEvents.DO_LOGIN, userId: user.id);
    } else if (user is Professional) {
      Mixpanel.trackEvent(MixpanelEvents.DO_LOGIN, userId: user.id);
    }
  }

  void _sendSignUpEvent(dynamic userOrFailure) {
    var user = userOrFailure.getOrElse(() => null);
    _updateUserInMixpanel(userOrFailure);
    if (user is Patient) {
      Mixpanel.trackEvent(MixpanelEvents.REGISTER_PATIENT, userId: user.id);
    } else if (user is Professional) {
      Mixpanel.trackEvent(MixpanelEvents.REGISTER_PROFESSIONAL, userId: user.id);
    }
  }

  void _updateUserInMixpanel(dynamic userOrFailure) {
    var user = userOrFailure.getOrElse(() => null);
    if (user is Patient) {
      Mixpanel.updateProfile(user.id, {
        "name": user.name,
        "email": user.email,
        "address": user.address,
        "birthday": Converter.getDateAsString(user.birthdate),
        "age": Converter.getAgeFromDate(user.birthdate),
        "role": "patient",
      });
    } else if (user is Professional) {
      Mixpanel.updateProfile(user.id, {
        "name": user.name,
        "email": user.email,
        "expertise": user.expertise,
        "role": "professional",
      });
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/error/failure.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/get_current_user.dart';
import 'package:cardio_flutter/features/auth/domain/usecases/sign_in.dart' as sign_in;
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_patient.dart' as sign_patient;
import 'package:cardio_flutter/features/auth/domain/usecases/sign_up_professional.dart' as sign_professional;
import 'package:cardio_flutter/resources/strings.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final sign_in.SignIn signIn;
  final sign_patient.SignUpPatient signUpPatient;
  final sign_professional.SignUpProfessional signUpProfessional;
  final GetCurrentUser getCurrentUser;

  // 1. O estado inicial agora é passado diretamente para o super()
  AuthBloc({
    required this.signIn,
    required this.signUpPatient,
    required this.signUpProfessional,
    required this.getCurrentUser,
  }) : super(InitialAuthState()) {
    
    // 2. Registramos os handlers de eventos (substitui o mapEventToState)
    on<SignInEvent>(_onSignIn);
    on<SignUpPatientEvent>(_onSignUpPatient);
    on<SignUpProfessionalEvent>(_onSignUpProfessional);
    on<GetUserStatusEvent>(_onGetUserStatus);

    // Dispara a checagem inicial de login
    add(GetUserStatusEvent());
  }

  // --- Handlers de Eventos ---

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(Loading());
    final failureOrUser = await signIn(
      sign_in.Params(email: event.email, password: event.password),
    );
    _handleLoggedResult(failureOrUser, emit);
  }

  Future<void> _onSignUpPatient(SignUpPatientEvent event, Emitter<AuthState> emit) async {
    emit(Loading());
    final failureOrUser = await signUpPatient(
      sign_patient.Params(patient: event.patient),
    );
    _handleSignedUpResult(failureOrUser, emit);
  }

  Future<void> _onSignUpProfessional(SignUpProfessionalEvent event, Emitter<AuthState> emit) async {
    emit(Loading());
    final failureOrUser = await signUpProfessional(
      sign_professional.Params(professional: event.professional, password: event.password),
    );
    _handleSignedUpResult(failureOrUser, emit);
  }

  Future<void> _onGetUserStatus(GetUserStatusEvent event, Emitter<AuthState> emit) async {
    final failureOrUser = await getCurrentUser(NoParams());
    _handleLoggedResult(failureOrUser, emit);
  }

  // --- Métodos Auxiliares para Emitir Estados ---

  void _handleLoggedResult(Either<Failure, dynamic> result, Emitter<AuthState> emit) {
    result.fold(
      (failure) {
        if (failure is UserNotCachedFailure) {
          emit(Empty());
        } else {
          emit(Error(message: Converter.convertFailureToMessage(failure)));
        }
      },
      (user) {
        if (user is Patient) {
          emit(LoggedPatient(patient: user));
        } else if (user is Professional) {
          emit(LoggedProfessional(professional: user));
        } else {
          emit(Error(message: Strings.invalid_user_type));
        }
      },
    );
  }

  void _handleSignedUpResult(Either<Failure, dynamic> result, Emitter<AuthState> emit) {
    result.fold(
      (failure) => emit(Error(message: Converter.convertFailureToMessage(failure))),
      (user) => emit(SignedUp(user: user)),
    );
  }
}
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  List<Object> get props => [];
}

class Empty extends AuthState {}

class LoggedPatient extends AuthState {}

class LoggedProfessional extends AuthState {}

class Loading extends AuthState {}

class SignedUp extends AuthState {}

class Error extends AuthState {
  final String message;

  Error({@required this.message});

  List<Object> get props => [message];
}

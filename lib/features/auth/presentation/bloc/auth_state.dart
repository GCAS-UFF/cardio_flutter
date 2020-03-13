part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  List<Object> get props => [];
}

class Empty extends AuthState {}

class LoggedPatient extends AuthState {
  final Patient patient;
  
  LoggedPatient ({@required this.patient});

  List<Object> get props => [patient];
}

class LoggedProfessional extends AuthState {
  final Professional professional;
  
  LoggedProfessional ({@required this.professional});

  List<Object> get props => [professional];
}

class Loading extends AuthState {}

class SignedUp extends AuthState {
  final dynamic user;
  
  SignedUp ({@required this.user});

  List<Object> get props => [user];
}

class Error extends AuthState {
  final String message;
  
  Error({@required this.message});

  List<Object> get props => [message];
}

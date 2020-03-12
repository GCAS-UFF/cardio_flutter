part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  List<Object> get props => [];
}

class Empty extends AuthState {}

class LoggedPatient extends AuthState {
  final User user;
  
  LoggedPatient ({@required this.user});

  List<Object> get props => [user];
}

class LoggedProfessional extends AuthState {
  final User user;
  
  LoggedProfessional ({@required this.user});

  List<Object> get props => [user];
}

class Loading extends AuthState {}

class SignedUp extends AuthState {
  final User user;
  
  SignedUp ({@required this.user});

  List<Object> get props => [user];
}

class Error extends AuthState {
  final String message;

  Error({@required this.message});

  List<Object> get props => [message];
}

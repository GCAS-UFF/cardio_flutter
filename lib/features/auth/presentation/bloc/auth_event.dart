part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({@required this.email, @required this.password});

  List<Object> get props => [email, password];
}

class SignUpPatientEvent extends AuthEvent {
  final Patient patient;

  SignUpPatientEvent({@required this.patient});

  List<Object> get props => [patient];
}

class SignUpProfessionalEvent extends AuthEvent {
  final Professional professional;
  final String password;

  SignUpProfessionalEvent(
      {@required this.professional, @required this.password});

  List<Object> get props => [professional, password];
}

class  GetUserStatusEvent extends AuthEvent {}

part of 'manage_professional_bloc.dart';

abstract class ManageProfessionalState extends Equatable {
  const ManageProfessionalState();

  List<Object> get props => [];
}

class Empty extends ManageProfessionalState {}

class Loading extends ManageProfessionalState {}

class Loaded extends ManageProfessionalState {
  final Professional professional;
  final List<Patient> patientList;

  Loaded({@required this.professional, @required this.patientList});

  List<Object> get props => [professional, patientList];
}

class Error extends ManageProfessionalState {
  final String message;

  Error({@required this.message});

  List<Object> get props => [message];
}

part of 'manage_professional_bloc.dart';

abstract class ManageProfessionalEvent extends Equatable {
  const ManageProfessionalEvent();
  List<Object> get props => [];
}

class Refresh extends ManageProfessionalEvent {
  final Professional professional;

  Refresh({@required this.professional});

  List<Object> get props => [professional];
}

class EditPatientEvent extends ManageProfessionalEvent {
  final Patient patient;

  EditPatientEvent({@required this.patient});

  List<Object> get props => [patient];
}

class DeletePatientEvent extends ManageProfessionalEvent {
  final Patient patient;

  DeletePatientEvent({@required this.patient});

  List<Object> get props => [patient];
}

class EditProfessionalEvent extends ManageProfessionalEvent {
  final Professional professional;

  EditProfessionalEvent({@required this.professional});

  List<Object> get props => [professional];
}
part of 'manage_professional_bloc.dart';

abstract class ManageProfessionalEvent extends Equatable {
  const ManageProfessionalEvent();
  List<Object> get props => [];
}

class Refresh extends ManageProfessionalEvent{}

class Start extends ManageProfessionalEvent {
  final User user;

  Start({@required this.user});

  List<Object> get props => [user];
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
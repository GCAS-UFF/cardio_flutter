part of 'generic_bloc.dart';

abstract class GenericState<Entity> extends Equatable {
  const GenericState();
}

class Empty<Entity> extends GenericState<Entity> {
  List<Object> get props => [];
}

class Loading<Entity> extends GenericState<Entity> {
  List<Object> get props => [];
}

class Loaded<Entity> extends GenericState<Entity> {
  final Patient patient;
  final Calendar calendar;

  Loaded({@required this.patient, @required this.calendar});

  List<Object> get props => [patient, calendar];
}

class Error<Entity> extends GenericState<Entity> {
  final String message;

  Error({@required this.message});

  List<Object> get props => [message];
}

part of 'generic_bloc.dart';

abstract class GenericEvent<Entity> extends Equatable {
  const GenericEvent();
  List<Object> get props => [];
}

class Start<Entity> extends GenericEvent<Entity> {
  final Patient patient;

  Start({@required this.patient});

  List<Object> get props => [patient];
}

class Refresh<Entity> extends GenericEvent<Entity> {}

class AddRecomendationEvent<Entity> extends GenericEvent<Entity> {
  final Entity entity;
  AddRecomendationEvent({
    @required this.entity,
  });
  List<Object> get props => [entity];
}

class EditRecomendationEvent<Entity> extends GenericEvent<Entity> {
  final Entity entity;

  EditRecomendationEvent({
    @required this.entity,
  });

  List<Object> get props => [entity];
}

class DeleteEvent<Entity> extends GenericEvent<Entity> {
  final Entity entity;

  DeleteEvent({
    @required this.entity,
  });

  List<Object> get props => [entity];
}

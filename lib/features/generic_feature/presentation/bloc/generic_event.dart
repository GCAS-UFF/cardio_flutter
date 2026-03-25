part of 'generic_bloc.dart';

abstract class GenericEvent<Entity> extends Equatable {
  const GenericEvent();

  @override
  List<Object?> get props => [];
}

class Start<Entity> extends GenericEvent<Entity> {
  final Patient patient;

  // 1. Trocado @required por required nativo
  const Start({required this.patient});

  @override
  List<Object?> get props => [patient];
}

class Refresh<Entity> extends GenericEvent<Entity> {
  @override
  List<Object?> get props => [];
}

class AddRecomendationEvent<Entity> extends GenericEvent<Entity> {
  final Entity entity;

  const AddRecomendationEvent({required this.entity});

  @override
  // 2. List<Object?> permite que o tipo genérico Entity seja incluído sem erro de cast
  List<Object?> get props => [entity];
}

class EditRecomendationEvent<Entity> extends GenericEvent<Entity> {
  final Entity entity;

  const EditRecomendationEvent({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class DeleteEvent<Entity> extends GenericEvent<Entity> {
  final Entity entity;

  const DeleteEvent({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class ExecuteEvent<Entity> extends GenericEvent<Entity> {
  final Entity entity;

  const ExecuteEvent({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class EditExecutedEvent<Entity> extends GenericEvent<Entity> {
  final Entity entity;

  const EditExecutedEvent({required this.entity});

  @override
  List<Object?> get props => [entity];
}
part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object?> get props => [];
}

class Start extends ExerciseEvent {
  final Patient patient;

  // 1. Trocamos @required pela palavra-chave required
  const Start({required this.patient});

  @override
  List<Object?> get props => [patient];
}

class Refresh extends ExerciseEvent {
  @override
  List<Object?> get props => [];
}

class AddExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  const AddExerciseEvent({required this.exercise});

  @override
  List<Object?> get props => [exercise];
}

class EditExerciseProfessionalEvent extends ExerciseEvent {
  final Exercise exercise;

  const EditExerciseProfessionalEvent({required this.exercise});

  @override
  List<Object?> get props => [exercise];
}

class ExecuteExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  const ExecuteExerciseEvent({required this.exercise});

  @override
  List<Object?> get props => [exercise];
}

class EditExecutedExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  const EditExecutedExerciseEvent({required this.exercise});

  @override
  List<Object?> get props => [exercise];
}

class DeleteExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  const DeleteExerciseEvent({required this.exercise});

  @override
  List<Object?> get props => [exercise];
}
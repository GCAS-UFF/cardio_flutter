part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();
  List<Object> get props => [];
}

class Start extends ExerciseEvent {
  final Patient patient;

  Start({@required this.patient});
  List<Object> get props => [patient];
}

class Refresh extends ExerciseEvent {}

class AddExerciseEvent extends ExerciseEvent {
  final Exercise exercise;
  final Patient patient;

  AddExerciseEvent({@required this.exercise, @required this.patient});
  List<Object> get props => [exercise];
}

class EditExerciseProfessionalEvent extends ExerciseEvent {
  final Exercise exercise;
  final Patient patient;

  EditExerciseProfessionalEvent({
    @required this.exercise,
    @required this.patient,
  });
  List<Object> get props => [exercise, patient];
}

class ExecuteExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  ExecuteExerciseEvent({@required this.exercise});
  List<Object> get props => [exercise];
}

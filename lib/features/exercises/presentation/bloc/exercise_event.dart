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
  AddExerciseEvent({
    @required this.exercise,
  });
  List<Object> get props => [exercise];
}

class EditExerciseProfessionalEvent extends ExerciseEvent {
  final Exercise exercise;

  EditExerciseProfessionalEvent({
    @required this.exercise,
  });
  List<Object> get props => [exercise];
}

class ExecuteExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  ExecuteExerciseEvent({@required this.exercise});
  List<Object> get props => [exercise];
}
class EditExecutedExerciseEvent extends ExerciseEvent {
  final Exercise exercise;

  EditExecutedExerciseEvent({@required this.exercise});
  List<Object> get props => [exercise];
}

class DeleteExerciseEvent extends ExerciseEvent{
final Exercise exercise;

  DeleteExerciseEvent({@required this.exercise,});
  List<Object> get props => [exercise];

}

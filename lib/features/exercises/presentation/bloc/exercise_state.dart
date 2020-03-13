part of 'exercise_bloc.dart';


abstract class ExerciseState extends Equatable {
  const ExerciseState();
}

class Empty extends ExerciseState {
  List<Object> get props => [];

}

class Loading extends ExerciseState {
  List<Object> get props => [];

}

class Loaded extends ExerciseState {
final Patient patient;
final List<Exercise> exerciseList;

  Loaded({@required this.patient, @required this.exerciseList});


  List<Object> get props => [patient, exerciseList];
  
}

class Error extends ExerciseState {
  final String message;

  Error({@required this.message});

  List<Object> get props => [message];

}

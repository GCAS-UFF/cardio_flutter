import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/usecases/add_exercise.dart'
    as add_exercise;
import 'package:cardio_flutter/features/exercises/domain/usecases/get_exercise_list.dart'
    as get_exercise_list;
import 'package:cardio_flutter/features/exercises/domain/usecases/execute_exercise.dart'
    as execute_exercise;
import 'package:cardio_flutter/features/exercises/domain/usecases/edit_exercise_professional.dart'
    as edit_exercise_professional;

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final add_exercise.AddExercise addExercise;
  final edit_exercise_professional.EditExerciseProfessional
      editExerciseProfessional;
  final execute_exercise.ExecuteExercise executeExercise;
  final get_exercise_list.GetExerciseList getExerciseList;
  Patient _currentPatient;

  ExerciseBloc(
      {@required this.addExercise,
      @required this.editExerciseProfessional,
      @required this.executeExercise,
      @required this.getExerciseList})
      : assert(addExercise != null),
        assert(editExerciseProfessional != null),
        assert(executeExercise != null),
        assert(getExerciseList != null);

  @override
  ExerciseState get initialState => Empty();

  @override
  Stream<ExerciseState> mapEventToState(
    ExerciseEvent event,
  ) async* {
    if (event is Start) {
      yield Loading();
      _currentPatient = event.patient;
      this.add(Refresh());
    } else if (event is Refresh) {
      yield Loading();
      var exerciseListOrError = await getExerciseList(
          get_exercise_list.Params(patient: _currentPatient));
      yield exerciseListOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (exerciseList) {
        return Loaded(patient: _currentPatient, exerciseList: exerciseList);
      });
    } else if (event is EditExerciseProfessionalEvent) {
      yield Loading();
      var exerciseOrError = await editExerciseProfessional(
          edit_exercise_professional.Params(
              exercise: event.exercise, patient: event.patient));
      yield exerciseOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        return Loading();
      });
    } else if (event is ExecuteExerciseEvent) {
      yield Loading();
      var exerciseOrError = await executeExercise(execute_exercise.Params(
          exercise: event.exercise, patient: _currentPatient));
      yield exerciseOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        return Loading();
      });
    } else if (event is AddExerciseEvent) {
      yield Loading();
      var exerciseOrError = await addExercise(add_exercise.Params(
          patient: event.patient, exercise: event.exercise));
      yield exerciseOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        return Loading();
      });
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/calendar.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/domain/usecases/delete_exercise.dart' as delete_exercise;

import 'package:cardio_flutter/features/exercises/domain/usecases/add_exercise.dart' as add_exercise;
import 'package:cardio_flutter/features/exercises/domain/usecases/get_exercise_list.dart' as get_exercise_list;
import 'package:cardio_flutter/features/exercises/domain/usecases/execute_exercise.dart' as execute_exercise;
import 'package:cardio_flutter/features/exercises/domain/usecases/edit_executed_exercise.dart' as edit_executed_exercise;

import 'package:cardio_flutter/features/exercises/domain/usecases/edit_exercise_professional.dart' as edit_exercise_professional;
import 'package:cardio_flutter/features/generic_feature/util/generic_converter.dart';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final add_exercise.AddExercise addExercise;
  final edit_exercise_professional.EditExerciseProfessional editExerciseProfessional;
  final execute_exercise.ExecuteExercise executeExercise;
  final edit_executed_exercise.EditExecutedExercise editExecutedExercise;
  final delete_exercise.DeleteExercise deleteExercise;
  final get_exercise_list.GetExerciseList getExerciseList;
  Patient _currentPatient;

  ExerciseBloc(
      {@required this.addExercise,
      @required this.deleteExercise,
      @required this.editExerciseProfessional,
      @required this.executeExercise,
      @required this.editExecutedExercise,
      @required this.getExerciseList})
      : assert(addExercise != null),
        assert(editExerciseProfessional != null),
        assert(executeExercise != null),
        assert(editExecutedExercise != null),
        assert(getExerciseList != null),
        assert(deleteExercise != null);

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
      var exerciseListOrError = await getExerciseList(get_exercise_list.Params(patient: _currentPatient));
      yield exerciseListOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (exerciseList) {
        Calendar calendar = Converter.convertExerciseToCalendar(exerciseList);
        return Loaded(patient: _currentPatient, calendar: calendar);
      });
    } else if (event is EditExerciseProfessionalEvent) {
      yield Loading();
      var exerciseOrError = await editExerciseProfessional(edit_exercise_professional.Params(exercise: event.exercise, patient: _currentPatient));
      yield exerciseOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        Mixpanel.trackEvent(
          MixpanelEvents.EDIT_RECOMMENDATION,
          data: {"actionType": "${GenericConverter.mapEntity(event.exercise)}"},
        );
        return Loading();
      });
    } else if (event is ExecuteExerciseEvent) {
      yield Loading();
      var exerciseOrError = await executeExercise(execute_exercise.Params(exercise: event.exercise, patient: _currentPatient));
      yield exerciseOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        Mixpanel.trackEvent(
          MixpanelEvents.DO_ACTION,
          data: {"actionType": "${GenericConverter.mapEntity(event.exercise)}"},
        );
        return Loading();
      });
    } else if (event is EditExecutedExerciseEvent) {
      yield Loading();
      var exerciseOrError = await editExecutedExercise(edit_executed_exercise.Params(exercise: event.exercise, patient: _currentPatient));
      yield exerciseOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        Mixpanel.trackEvent(
          MixpanelEvents.EDIT_ACTION,
          data: {"actionType": "${GenericConverter.mapEntity(event.exercise)}"},
        );
        return Loading();
      });
    } else if (event is AddExerciseEvent) {
      yield Loading();
      var exerciseOrError = await addExercise(add_exercise.Params(exercise: event.exercise, patient: _currentPatient));
      yield exerciseOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        Mixpanel.trackEvent(
          MixpanelEvents.RECOMMEND_ACTION,
          data: {"actionType": "${GenericConverter.mapEntity(event.exercise)}"},
        );
        return Loading();
      });
    } else if (event is DeleteExerciseEvent) {
      yield Loading();
      var voidOrError = await deleteExercise(delete_exercise.Params(exercise: event.exercise, patient: _currentPatient));
      yield voidOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        Mixpanel.trackEvent(
          GenericConverter.isAction(event.exercise) ? MixpanelEvents.DELETE_ACTION : MixpanelEvents.DELETE_RECOMMENDATION,
          data: {"actionType": "${GenericConverter.mapEntity(event.exercise)}"},
        );
        return Loading();
      });
    }
  }
}

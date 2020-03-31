import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/calendar.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/add_recomendation.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'generic_event.dart';
part 'generic_state.dart';

class GenericBloc<Entity>
    extends Bloc<GenericEvent<Entity>, GenericState<Entity>> {
  final AddRecomendation<Entity> addRecomendation;
  Patient _currentPatient;

  GenericBloc({@required this.addRecomendation})
      : assert(addRecomendation != null);

  @override
  GenericState<Entity> get initialState => Empty<Entity>();

  @override
  Stream<GenericState<Entity>> mapEventToState(
    GenericEvent<Entity> event,
  ) async* {
    if (event is Start<Entity>) {
      yield Loading<Entity>();
      _currentPatient = event.patient;
      this.add(Refresh<Entity>());
    } else if (event is Refresh<Entity>) {
      yield Loading<Entity>();
      // var recomendationListOrError = await getExerciseList(
      //     get_exercise_list.Params(patient: _currentPatient));
      // yield exerciseListOrError.fold((failure) {
      //   return Error(message: Converter.convertFailureToMessage(failure));
      // }, (exerciseList) {
      //   Calendar calendar = Converter.convertExerciseToCalendar(exerciseList);
      yield Loaded(patient: _currentPatient, calendar: Calendar());
      // });
    } else if (event is AddRecomendationEvent<Entity>) {
      yield Loading<Entity>();
      var recomendationOrError = await addRecomendation(
          Params<Entity>(entity: event.entity, patient: _currentPatient));
      yield recomendationOrError.fold((failure) {
        return Error<Entity>(
            message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh<Entity>());
        return Loading<Entity>();
      });
    }
  }
}

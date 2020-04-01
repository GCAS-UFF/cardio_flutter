import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/calendar.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/add_recomendation.dart'
    as add_recomendation;
import 'package:cardio_flutter/features/generic_feature/domain/usecases/get_list.dart'
    as get_list;
import 'package:cardio_flutter/features/generic_feature/util/calendar_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'generic_event.dart';
part 'generic_state.dart';

class GenericBloc<Entity extends BaseEntity>
    extends Bloc<GenericEvent<Entity>, GenericState<Entity>> {
  final add_recomendation.AddRecomendation<Entity> addRecomendation;
  final get_list.GetList<Entity> getList;

  Patient _currentPatient;

  GenericBloc({@required this.addRecomendation, @required this.getList})
      : assert(addRecomendation != null),
        assert(getList != null);

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
      var listOrError =
          await getList(get_list.Params(patient: _currentPatient));
      yield listOrError.fold((failure) {
        return Error<Entity>(
            message: Converter.convertFailureToMessage(failure));
      }, (list) {
        Calendar calendar = CalendarConverter.convertEntityListToCalendar(list);
        return Loaded(patient: _currentPatient, calendar: calendar);
      });
    } else if (event is AddRecomendationEvent<Entity>) {
      yield Loading<Entity>();
      var recomendationOrError = await addRecomendation(
          add_recomendation.Params<Entity>(
              entity: event.entity, patient: _currentPatient));
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

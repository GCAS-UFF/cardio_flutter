import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/calendar.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:cardio_flutter/features/generic_feature/domain/usecases/add_recomendation.dart' as add_recomendation;
import 'package:cardio_flutter/features/generic_feature/domain/usecases/delete.dart' as delete_class;
import 'package:cardio_flutter/features/generic_feature/domain/usecases/edit_executed.dart' as edit_executed;
import 'package:cardio_flutter/features/generic_feature/domain/usecases/edit_recomendation.dart' as edit_recomendation;
import 'package:cardio_flutter/features/generic_feature/domain/usecases/execute.dart' as execute_class;
import 'package:cardio_flutter/features/generic_feature/domain/usecases/get_list.dart' as get_list;
import 'package:cardio_flutter/features/generic_feature/util/calendar_converter.dart';
import 'package:cardio_flutter/features/generic_feature/util/generic_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'generic_event.dart';
part 'generic_state.dart';

class GenericBloc<Entity extends BaseEntity> extends Bloc<GenericEvent<Entity>, GenericState<Entity>> {
  final add_recomendation.AddRecomendation<Entity> addRecomendation;
  final get_list.GetList<Entity> getList;
  final edit_recomendation.EditRecomendation<Entity> editRecomendation;
  final delete_class.Delete<Entity> delete;
  final execute_class.Execute<Entity> execute;
  final edit_executed.EditExecuted<Entity> editExecuted;

  Patient _currentPatient;

  GenericBloc(
      {@required this.addRecomendation,
      @required this.getList,
      @required this.editRecomendation,
      @required this.delete,
      @required this.execute,
      @required this.editExecuted})
      : assert(addRecomendation != null),
        assert(getList != null),
        assert(editRecomendation != null),
        assert(delete != null),
        assert(execute != null),
        assert(editExecuted != null);

  @override
  GenericState<Entity> get initialState => Empty<Entity>();

  @override
  Stream<GenericState<Entity>> mapEventToState(
    GenericEvent<Entity> event,
  ) async* {
    print(event);
    if (event is Start<Entity>) {
      yield Loading<Entity>();
      _currentPatient = event.patient;
      this.add(Refresh<Entity>());
    } else if (event is Refresh<Entity>) {
      yield Loading<Entity>();
      var listOrError = await getList(get_list.Params(patient: _currentPatient));
      yield listOrError.fold((failure) {
        return Error<Entity>(message: Converter.convertFailureToMessage(failure));
      }, (list) {
        Calendar calendar = CalendarConverter.convertEntityListToCalendar(list);
        return Loaded(patient: _currentPatient, calendar: calendar);
      });
    } else if (event is AddRecomendationEvent<Entity>) {
      yield Loading<Entity>();
      var recomendationOrError = await addRecomendation(add_recomendation.Params<Entity>(entity: event.entity, patient: _currentPatient));
      yield recomendationOrError.fold((failure) {
        return Error<Entity>(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh<Entity>());
        Mixpanel.trackEvent(
          MixpanelEvents.RECOMMEND_ACTION,
          data: {"actionType": "${GenericConverter.mapEntity(event.entity)}"},
        );
        return Loading<Entity>();
      });
    } else if (event is EditRecomendationEvent<Entity>) {
      yield Loading<Entity>();
      var recomendationOrError = await editRecomendation(edit_recomendation.Params<Entity>(entity: event.entity, patient: _currentPatient));
      yield recomendationOrError.fold((failure) {
        return Error<Entity>(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh<Entity>());
        Mixpanel.trackEvent(
          MixpanelEvents.EDIT_RECOMMENDATION,
          data: {"actionType": "${GenericConverter.mapEntity(Entity)}"},
        );
        return Loading<Entity>();
      });
    } else if (event is DeleteEvent<Entity>) {
      yield Loading<Entity>();
      var voidOrError = await delete(delete_class.Params<Entity>(entity: event.entity, patient: _currentPatient));
      yield voidOrError.fold((failure) {
        return Error<Entity>(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh<Entity>());
        Mixpanel.trackEvent(
          GenericConverter.isAction(event.entity) ? MixpanelEvents.DELETE_ACTION : MixpanelEvents.DELETE_RECOMMENDATION,
          data: {"actionType": "${GenericConverter.mapEntity(Entity)}"},
        );
        return Loading<Entity>();
      });
    } else if (event is ExecuteEvent<Entity>) {
      yield Loading<Entity>();
      var entityOrError = await execute(execute_class.Params<Entity>(entity: event.entity, patient: _currentPatient));
      yield entityOrError.fold((failure) {
        return Error<Entity>(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh<Entity>());
        Mixpanel.trackEvent(
          MixpanelEvents.DO_ACTION,
          data: {"actionType": "${GenericConverter.mapEntity(Entity)}"},
        );
        return Loading<Entity>();
      });
    } else if (event is EditExecutedEvent<Entity>) {
      yield Loading<Entity>();
      var entityOrError = await editExecuted(edit_executed.Params<Entity>(entity: event.entity, patient: _currentPatient));
      yield entityOrError.fold((failure) {
        return Error<Entity>(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh<Entity>());
        Mixpanel.trackEvent(
          MixpanelEvents.EDIT_ACTION,
          data: {"actionType": "${GenericConverter.mapEntity(Entity)}"},
        );
        return Loading<Entity>();
      });
    }
  }
}

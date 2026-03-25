import 'dart:async';
import 'package:bloc/bloc.dart';
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
import 'package:equatable/equatable.dart';

part 'generic_event.dart';
part 'generic_state.dart';

class GenericBloc<Entity extends BaseEntity>
    extends Bloc<GenericEvent<Entity>, GenericState<Entity>> {
  final add_recomendation.AddRecomendation<Entity> addRecomendation;
  final get_list.GetList<Entity> getList;
  final edit_recomendation.EditRecomendation<Entity> editRecomendation;
  final delete_class.Delete<Entity> delete;
  final execute_class.Execute<Entity> execute;
  final edit_executed.EditExecuted<Entity> editExecuted;

  // 1. 'late' para garantir inicialização no evento Start
  late Patient _currentPatient;

  GenericBloc({
    required this.addRecomendation,
    required this.getList,
    required this.editRecomendation,
    required this.delete,
    required this.execute,
    required this.editExecuted,
  }) : super(Empty<Entity>()) { // 2. Estado inicial no super()
    
    // 3. Registro dos handlers (Bloc 8+)
    on<Start<Entity>>(_onStart);
    on<Refresh<Entity>>(_onRefresh);
    on<AddRecomendationEvent<Entity>>(_onAddRecomendation);
    on<EditRecomendationEvent<Entity>>(_onEditRecomendation);
    on<DeleteEvent<Entity>>(_onDelete);
    on<ExecuteEvent<Entity>>(_onExecute);
    on<EditExecutedEvent<Entity>>(_onEditExecuted);
  }

  // --- Handlers ---

  Future<void> _onStart(Start<Entity> event, Emitter<GenericState<Entity>> emit) async {
    emit(Loading<Entity>());
    _currentPatient = event.patient;
    add(Refresh<Entity>());
  }

  Future<void> _onRefresh(Refresh<Entity> event, Emitter<GenericState<Entity>> emit) async {
    emit(Loading<Entity>());
    final result = await getList(get_list.Params(patient: _currentPatient));
    
    result.fold(
      (failure) => emit(Error<Entity>(message: Converter.convertFailureToMessage(failure))),
      (list) {
        Calendar calendar = CalendarConverter.convertEntityListToCalendar(list);
        emit(Loaded<Entity>(patient: _currentPatient, calendar: calendar));
      },
    );
  }

  Future<void> _onAddRecomendation(AddRecomendationEvent<Entity> event, Emitter<GenericState<Entity>> emit) async {
    emit(Loading<Entity>());
    final result = await addRecomendation(add_recomendation.Params<Entity>(
        entity: event.entity, patient: _currentPatient));
    _handleWriteResult(result, emit);
  }

  Future<void> _onEditRecomendation(EditRecomendationEvent<Entity> event, Emitter<GenericState<Entity>> emit) async {
    emit(Loading<Entity>());
    final result = await editRecomendation(edit_recomendation.Params<Entity>(
        entity: event.entity, patient: _currentPatient));
    _handleWriteResult(result, emit);
  }

  Future<void> _onDelete(DeleteEvent<Entity> event, Emitter<GenericState<Entity>> emit) async {
    emit(Loading<Entity>());
    final result = await delete(delete_class.Params<Entity>(
        entity: event.entity, patient: _currentPatient));
    _handleWriteResult(result, emit);
  }

  Future<void> _onExecute(ExecuteEvent<Entity> event, Emitter<GenericState<Entity>> emit) async {
    emit(Loading<Entity>());
    final result = await execute(execute_class.Params<Entity>(
        entity: event.entity, patient: _currentPatient));
    _handleWriteResult(result, emit);
  }

  Future<void> _onEditExecuted(EditExecutedEvent<Entity> event, Emitter<GenericState<Entity>> emit) async {
    emit(Loading<Entity>());
    final result = await editExecuted(edit_executed.Params<Entity>(
        entity: event.entity, patient: _currentPatient));
    _handleWriteResult(result, emit);
  }

  // Helper para lidar com o retorno das UseCases
  void _handleWriteResult(dynamic result, Emitter<GenericState<Entity>> emit) {
    result.fold(
      (failure) => emit(Error<Entity>(message: Converter.convertFailureToMessage(failure))),
      (_) => add(Refresh<Entity>()),
    );
  }
}
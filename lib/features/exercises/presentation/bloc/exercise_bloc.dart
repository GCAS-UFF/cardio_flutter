import 'package:bloc/bloc.dart';
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
  
  // 1. 'late' indica que será inicializado no evento 'Start' antes do uso.
  late Patient _currentPatient;

  ExerciseBloc({
    required this.addExercise,
    required this.deleteExercise,
    required this.editExerciseProfessional,
    required this.executeExercise,
    required this.editExecutedExercise,
    required this.getExerciseList,
  }) : super(Empty()) { // 2. Estado inicial definido no super()
    
    // 3. Registro dos handlers (Substitui o mapEventToState)
    on<Start>(_onStart);
    on<Refresh>(_onRefresh);
    on<EditExerciseProfessionalEvent>(_onEditExerciseProfessional);
    on<ExecuteExerciseEvent>(_onExecuteExercise);
    on<EditExecutedExerciseEvent>(_onEditExecutedExercise);
    on<AddExerciseEvent>(_onAddExercise);
    on<DeleteExerciseEvent>(_onDeleteExercise);
  }

  // --- Handlers de Eventos ---

  Future<void> _onStart(Start event, Emitter<ExerciseState> emit) async {
    emit(Loading());
    _currentPatient = event.patient;
    add(Refresh());
  }

  Future<void> _onRefresh(Refresh event, Emitter<ExerciseState> emit) async {
    emit(Loading());
    final result = await getExerciseList(get_exercise_list.Params(patient: _currentPatient));
    
    result.fold(
      (failure) => emit(Error(message: Converter.convertFailureToMessage(failure))),
      (exerciseList) {
        Calendar calendar = Converter.convertExerciseToCalendar(exerciseList);
        emit(Loaded(patient: _currentPatient, calendar: calendar));
      },
    );
  }

  Future<void> _onEditExerciseProfessional(EditExerciseProfessionalEvent event, Emitter<ExerciseState> emit) async {
    emit(Loading());
    final result = await editExerciseProfessional(
      edit_exercise_professional.Params(exercise: event.exercise, patient: _currentPatient),
    );
    _handleWriteResult(result, emit);
  }

  Future<void> _onExecuteExercise(ExecuteExerciseEvent event, Emitter<ExerciseState> emit) async {
    emit(Loading());
    final result = await executeExercise(
      execute_exercise.Params(exercise: event.exercise, patient: _currentPatient),
    );
    _handleWriteResult(result, emit);
  }

  Future<void> _onEditExecutedExercise(EditExecutedExerciseEvent event, Emitter<ExerciseState> emit) async {
    emit(Loading());
    final result = await editExecutedExercise(
      edit_executed_exercise.Params(exercise: event.exercise, patient: _currentPatient),
    );
    _handleWriteResult(result, emit);
  }

  Future<void> _onAddExercise(AddExerciseEvent event, Emitter<ExerciseState> emit) async {
    emit(Loading());
    final result = await addExercise(
      add_exercise.Params(exercise: event.exercise, patient: _currentPatient),
    );
    _handleWriteResult(result, emit);
  }

  Future<void> _onDeleteExercise(DeleteExerciseEvent event, Emitter<ExerciseState> emit) async {
    emit(Loading());
    final result = await deleteExercise(
      delete_exercise.Params(exercise: event.exercise, patient: _currentPatient),
    );
    _handleWriteResult(result, emit);
  }

  // --- Helper para evitar repetição de código ---

  void _handleWriteResult(dynamic result, Emitter<ExerciseState> emit) {
    result.fold(
      (failure) => emit(Error(message: Converter.convertFailureToMessage(failure))),
      (_) {
        add(Refresh());
        // Não emitimos nada aqui, o Refresh se encarregará de emitir Loading -> Loaded/Error
      },
    );
  }
}
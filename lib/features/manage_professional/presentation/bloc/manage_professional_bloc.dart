import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/delete_patient_list.dart'
    as delete_patient;
import 'package:cardio_flutter/features/manage_professional/domain/usecases/edit_patient.dart'
    as edit_patient;
import 'package:cardio_flutter/features/manage_professional/domain/usecases/edit_professional.dart'
    as edit_professional;
import 'package:cardio_flutter/features/manage_professional/domain/usecases/get_patient_list.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/get_professional.dart'
    as get_professional;
import 'package:equatable/equatable.dart';

part 'manage_professional_event.dart';
part 'manage_professional_state.dart';

class ManageProfessionalBloc
    extends Bloc<ManageProfessionalEvent, ManageProfessionalState> {
  final delete_patient.DeletePatientFromList deletePatientFromList;
  final edit_patient.EditPatientFromList editPatientFromList;
  final GetPatientList getPatientList;
  final edit_professional.EditProfessional editProfessional;
  final get_professional.GetProfessional getProfessional;

  // 1. 'late' permite que ela seja inicializada depois, e Professional? caso comece nula
  Professional? _currentProfessional;

  ManageProfessionalBloc({
    required this.deletePatientFromList,
    required this.editPatientFromList,
    required this.getPatientList,
    required this.editProfessional,
    required this.getProfessional,
  }) : super(Empty()) {
    // 2. No Bloc moderno, registramos os eventos no construtor usando 'on'
    on<Start>(_onStart);
    on<Refresh>(_onRefresh);
    on<EditPatientEvent>(_onEditPatient);
    on<EditProfessionalEvent>(_onEditProfessional);
    on<DeletePatientEvent>(_onDeletePatient);
  }

  // 3. Substitutos do antigo mapEventToState
  Future<void> _onStart(Start event, Emitter<ManageProfessionalState> emit) async {
    emit(Loading());
    _currentProfessional = event.professional;
    add(Refresh());
  }

  Future<void> _onRefresh(Refresh event, Emitter<ManageProfessionalState> emit) async {
    emit(Loading());
    var patientListOrError = await getPatientList(NoParams());
    
    patientListOrError.fold(
      (failure) => emit(Error(message: Converter.convertFailureToMessage(failure))),
      (patientList) => emit(Loaded(
        patientList: patientList, 
        professional: _currentProfessional! // Usamos ! pois o Start já o definiu
      )),
    );
  }

  Future<void> _onEditPatient(EditPatientEvent event, Emitter<ManageProfessionalState> emit) async {
    emit(Loading());
    var patientOrError = await editPatientFromList(
      edit_patient.Params(patient: event.patient),
    );
    patientOrError.fold(
      (failure) => emit(Error(message: Converter.convertFailureToMessage(failure))),
      (result) => add(Refresh()),
    );
  }

  Future<void> _onEditProfessional(EditProfessionalEvent event, Emitter<ManageProfessionalState> emit) async {
    emit(Loading());
    var professionalOrError = await editProfessional(
        edit_professional.Params(professional: event.professional));
    
    professionalOrError.fold(
      (failure) => emit(Error(message: Converter.convertFailureToMessage(failure))),
      (result) {
        _currentProfessional = result;
        add(Refresh());
      },
    );
  }

  Future<void> _onDeletePatient(DeletePatientEvent event, Emitter<ManageProfessionalState> emit) async {
    emit(Loading());
    var voidOrError = await deletePatientFromList(
        delete_patient.Params(patient: event.patient));
    
    voidOrError.fold(
      (failure) => emit(Error(message: Converter.convertFailureToMessage(failure))),
      (result) => add(Refresh()),
    );
  }
}
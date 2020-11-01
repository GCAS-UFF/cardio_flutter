import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/core/usecases/usecase.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/delete_patient_list.dart' as delete_patient;
import 'package:cardio_flutter/features/manage_professional/domain/usecases/edit_patient.dart' as edit_patient;
import 'package:cardio_flutter/features/manage_professional/domain/usecases/edit_professional.dart' as edit_professional;
import 'package:cardio_flutter/features/manage_professional/domain/usecases/get_patient_list.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/get_professional.dart' as get_professional;
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'manage_professional_event.dart';
part 'manage_professional_state.dart';

class ManageProfessionalBloc extends Bloc<ManageProfessionalEvent, ManageProfessionalState> {
  final delete_patient.DeletePatientFromList deletePatientFromList;
  final edit_patient.EditPatientFromList editPatientFromList;
  final GetPatientList getPatientList;
  final edit_professional.EditProfessional editProfessional;
  final get_professional.GetProfessional getProfessional;

  Professional _currentProfessional;

  ManageProfessionalBloc(
      {@required this.deletePatientFromList,
      @required this.editPatientFromList,
      @required this.getPatientList,
      @required this.editProfessional,
      @required this.getProfessional})
      : assert(deletePatientFromList != null),
        assert(editPatientFromList != null),
        assert(getPatientList != null),
        assert(editProfessional != null),
        assert(getProfessional != null);

  @override
  ManageProfessionalState get initialState => Empty();

  @override
  Stream<ManageProfessionalState> mapEventToState(
    ManageProfessionalEvent event,
  ) async* {
    if (event is Start) {
      yield Loading();

      _currentProfessional = event.professional;
      this.add(Refresh());
    } else if (event is Refresh) {
      // Show loading for the user
      yield Loading();
      // Get current patient list
      var patientListOrError = await getPatientList(NoParams());
      // Test if the result was success or error
      yield patientListOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (patientList) {
        return Loaded(patientList: patientList, professional: _currentProfessional);
      });
    } else if (event is EditPatientEvent) {
      yield Loading();
      var patientOrError = await editPatientFromList(
        edit_patient.Params(patient: event.patient),
      );
      yield patientOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        Mixpanel.trackEvent(
          MixpanelEvents.EDIT_PATIENT,
          data: {"patientEdited": event.patient.id},
        );
        return Loading();
      });
    } else if (event is EditProfessionalEvent) {
      yield Loading();
      var professionalOrError = await editProfessional(edit_professional.Params(professional: event.professional));
      yield professionalOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        _currentProfessional = result;
        this.add(Refresh());
        Mixpanel.trackEvent(MixpanelEvents.EDIT_PROFESSIONAL);
        return Loading();
      });
    } else if (event is DeletePatientEvent) {
      yield Loading();
      var voidOrError = await deletePatientFromList(delete_patient.Params(patient: event.patient));
      yield voidOrError.fold((failure) {
        return Error(message: Converter.convertFailureToMessage(failure));
      }, (result) {
        this.add(Refresh());
        Mixpanel.trackEvent(
          MixpanelEvents.DELETE_PATIENT,
          data: {"patientDeleted": event.patient.id},
        );
        return Loading();
      });
    }
  }
}

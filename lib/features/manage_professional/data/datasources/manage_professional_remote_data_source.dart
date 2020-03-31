import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/data/models/profissional_model.dart';
import 'package:cardio_flutter/features/auth/data/models/user_model.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

abstract class ManageProfessionalRemoteDataSource {
  Future<PatientModel> editPatient(PatientModel patientModel);
  Future<void> deletePatient(String professionalId, PatientModel patientModel);
  Future<List<PatientModel>> getPatientList(String professionalId);
  Future<ProfessionalModel> editProfessional(
      ProfessionalModel professionalModel);
  Future<ProfessionalModel> getProfessional(UserModel userModel);
}

class ManageProfessionalRemoteDataSourceImpl
    implements ManageProfessionalRemoteDataSource {
  final FirebaseDatabase firebaseDatabase;
  final FirebaseAuth firebaseAuth;
  final DatabaseReference patientRootRef =
      FirebaseDatabase.instance.reference().child('Patient');
  final DatabaseReference professionalRootRef =
      FirebaseDatabase.instance.reference().child('Professional');

  ManageProfessionalRemoteDataSourceImpl(
      {@required this.firebaseDatabase, @required this.firebaseAuth});

  @override
  Future<void> deletePatient(
      String professionalId, PatientModel patientModel) async {
    try {
      var refPatientInPatientList = professionalRootRef
          .child(professionalId)
          .child("PatientList")
          .child(patientModel.id);
      var refPatient = patientRootRef.child(patientModel.id);

      await refPatientInPatientList.remove();
      await refPatient.remove();
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<PatientModel> editPatient(PatientModel patientModel) async {
    try {
      var refPatient = patientRootRef.child(patientModel.id);
      await refPatient.set(patientModel.toJson());

      DataSnapshot patientSnapshot = await refPatient.once();
      return PatientModel.fromDataSnapshot(patientSnapshot);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ProfessionalModel> editProfessional(
      ProfessionalModel professionalModel) async {
    try {
      var refProfessional = professionalRootRef.child(professionalModel.id);
      await refProfessional.set(professionalModel.toJson());

      DataSnapshot professionalSnapshot = await refProfessional.once();
      return ProfessionalModel.fromDataSnapshot(professionalSnapshot);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<List<PatientModel>> getPatientList(String professionalId) async {
    try {
      // Get professional patient list reference
      var refPatientList =
          professionalRootRef.child(professionalId).child("PatientList");

      // Create list to store results
      List<PatientModel> result = List<PatientModel>();

      // Get professional patient list values
      DataSnapshot patientListSnapshot = await refPatientList.once();

      // Transform datasnapshot to map for iteration
      Map<dynamic, dynamic> objectMap =
          patientListSnapshot.value as Map<dynamic, dynamic>;

      // For each string will be returned one patient
      if (objectMap != null) {
        for (MapEntry<dynamic, dynamic> entry in objectMap.entries) {
          var refPatient = patientRootRef.child(entry.key);
          DataSnapshot patientSnapshot = await refPatient.once();
          result.add(PatientModel.fromDataSnapshot(patientSnapshot));
        }
      }

      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ProfessionalModel> getProfessional(UserModel userModel) async {
    if (userModel == null ||
        userModel.type == null ||
        userModel.type != Keys.PROFESSIONAL_TYPE) throw ServerException();

    try {
      var refProfessional = professionalRootRef.child(userModel.id);

      DataSnapshot professionalSnapshot = await refProfessional.once();
      return ProfessionalModel.fromDataSnapshot(professionalSnapshot);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }
}

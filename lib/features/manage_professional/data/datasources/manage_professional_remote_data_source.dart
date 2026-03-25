import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/data/models/professional_model.dart';
import 'package:cardio_flutter/features/auth/data/models/user_model.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

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
  
  // 1. '.reference()' foi depreciado. Usamos '.ref()' agora.
  final DatabaseReference patientRootRef =
      FirebaseDatabase.instance.ref().child('Patient');
  final DatabaseReference professionalRootRef =
      FirebaseDatabase.instance.ref().child('Professional');

  // 2. Mudança de @required para required nativo do Null Safety
  ManageProfessionalRemoteDataSourceImpl(
      {required this.firebaseDatabase, required this.firebaseAuth});

  @override
  Future<void> deletePatient(
      String professionalId, PatientModel patientModel) async {
    try {
      // 3. Adicionado o '!' pois o child() não aceita strings nulas (String?)
      var refPatientInPatientList = professionalRootRef
          .child(professionalId)
          .child("PatientList")
          .child(patientModel.id!);
      var refPatient = patientRootRef.child(patientModel.id!);

      await refPatientInPatientList.remove();
      await refPatient.remove();
    } on PlatformException catch (_) {
      rethrow; // Prática recomendada pelo Dart no lugar de 'throw e;'
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<PatientModel> editPatient(PatientModel patientModel) async {
    try {
      var refPatient = patientRootRef.child(patientModel.id!);
      await refPatient.update(patientModel.toJson());

      // 4. once() retorna um DatabaseEvent. Extraímos o snapshot dele.
      DatabaseEvent event = await refPatient.once();
      return PatientModel.fromDataSnapshot(event.snapshot);
    } on PlatformException catch (_) {
      rethrow;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ProfessionalModel> editProfessional(
      ProfessionalModel professionalModel) async {
    try {
      var refProfessional = professionalRootRef.child(professionalModel.id!);
      await refProfessional.update(professionalModel.toJson());

      DatabaseEvent event = await refProfessional.once();
      return ProfessionalModel.fromDataSnapshot(event.snapshot);
    } on PlatformException catch (_) {
      rethrow;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<List<PatientModel>> getPatientList(String professionalId) async {
    try {
      var refPatientList =
          professionalRootRef.child(professionalId).child("PatientList");

      // 5. O construtor List() foi removido no Dart 3. Usamos as chaves [].
      List<PatientModel> result = [];

      DatabaseEvent event = await refPatientList.once();
      final snapshotValue = event.snapshot.value;

      if (snapshotValue != null) {
        // 6. Conversão segura do Map vindo do Firebase
        Map<dynamic, dynamic> objectMap = Map<dynamic, dynamic>.from(snapshotValue as Map);

        for (MapEntry<dynamic, dynamic> entry in objectMap.entries) {
          var refPatient = patientRootRef.child(entry.key.toString());
          DatabaseEvent patientEvent = await refPatient.once();
          
          if (patientEvent.snapshot.value != null) {
             result.add(PatientModel.fromDataSnapshot(patientEvent.snapshot));
          }
        }
      }

      return result;
    } on PlatformException catch (_) {
      rethrow;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ProfessionalModel> getProfessional(UserModel userModel) async {
    // 7. Removida a checagem 'userModel == null' pois a variável não é UserModel? (não pode ser nula)
    if (userModel.type != Keys.PROFESSIONAL_TYPE) {
      throw ServerException();
    }

    try {
      var refProfessional = professionalRootRef.child(userModel.id!);

      DatabaseEvent event = await refProfessional.once();
      return ProfessionalModel.fromDataSnapshot(event.snapshot);
    } on PlatformException catch (_) {
      rethrow;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }
}
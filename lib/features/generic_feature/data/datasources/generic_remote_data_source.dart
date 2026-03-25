import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/generic_feature/util/generic_converter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cardio_flutter/core/error/exception.dart';
import 'package:flutter/services.dart';

abstract class GenericRemoteDataSource<Model> {
  Future<Model> addRecommendation(PatientModel patientModel, Model model);
  Future<Model> editRecommendation(
      PatientModel patientModel, Model model, String id);
  Future<List<Model>> getList(PatientModel patientModel);
  Future<void> delete(PatientModel patientModel, bool done, String id);
  Future<Model> execute(PatientModel patientModel, Model model);
  Future<Model> editExecuted(PatientModel patientModel, Model model, String id);
}

class GenericRemoteDataSourceImpl<Model>
    implements GenericRemoteDataSource<Model> {
  final FirebaseDatabase firebaseDatabase;
  final String firebaseTag;
  final String type;

  // 1. Uso de ref() e instância injetada para melhor arquitetura
  DatabaseReference get _patientRootRef => firebaseDatabase.ref('Patient');

  GenericRemoteDataSourceImpl({
    required this.firebaseDatabase,
    required this.firebaseTag,
    required this.type,
  });

  @override
  Future<Model> addRecommendation(PatientModel patientModel, Model model) async {
    try {
      // 2. Garantindo que o ID do paciente não é nulo com '!'
      DatabaseReference recommendationRef = _patientRootRef
          .child(patientModel.id!)
          .child('ToDo')
          .child(firebaseTag)
          .push();

      await recommendationRef
          .set(GenericConverter.genericToJson<Model>(type, model));

      // 3. Capturando o snapshot através do DatabaseEvent
      DatabaseEvent event = await recommendationRef.once();
      var result = GenericConverter.genericFromDataSnapshot(
          type, event.snapshot, false);

      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[GenericRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<List<Model>> getList(PatientModel patientModel) async {
    try {
      // 4. Inicialização de lista compatível com Dart 3
      List<Model> result = [];

      final String patientId = patientModel.id!;

      // Busca na lista ToDo
      DatabaseReference refToDoList = _patientRootRef
          .child(patientId)
          .child('ToDo')
          .child(firebaseTag);
      DatabaseEvent toDoEvent = await refToDoList.once();
      result.addAll(GenericConverter.genericFromDataSnapshotList(
          type, toDoEvent.snapshot, false));

      // Busca na lista Done
      DatabaseReference refDoneList = _patientRootRef
          .child(patientId)
          .child('Done')
          .child(firebaseTag);
      DatabaseEvent doneEvent = await refDoneList.once();
      result.addAll(GenericConverter.genericFromDataSnapshotList(
          type, doneEvent.snapshot, true));

      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[GenericRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<Model> editRecommendation(
      PatientModel patientModel, Model model, String id) async {
    try {
      DatabaseReference ref = _patientRootRef
          .child(patientModel.id!)
          .child('ToDo')
          .child(firebaseTag)
          .child(id);

      await ref.set(GenericConverter.genericToJson<Model>(type, model));
      
      DatabaseEvent event = await ref.once();
      Model result =
          GenericConverter.genericFromDataSnapshot(type, event.snapshot, false);
      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[GenericRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<void> delete(PatientModel patientModel, bool done, String id) async {
    try {
      String path = done ? "Done" : "ToDo";
      DatabaseReference refDel = _patientRootRef
          .child(patientModel.id!)
          .child(path)
          .child(firebaseTag)
          .child(id);
      await refDel.remove();
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[GenericRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<Model> editExecuted(
      PatientModel patientModel, Model model, String id) async {
    try {
      DatabaseReference doneRef = _patientRootRef
          .child(patientModel.id!)
          .child('Done')
          .child(firebaseTag)
          .child(id);

      await doneRef.set(GenericConverter.genericToJson<Model>(type, model));
      
      DatabaseEvent event = await doneRef.once();
      Model result =
          GenericConverter.genericFromDataSnapshot(type, event.snapshot, true);
      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[GenericRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<Model> execute(PatientModel patientModel, Model model) async {
    try {
      DatabaseReference doneRef = _patientRootRef
          .child(patientModel.id!)
          .child('Done')
          .child(firebaseTag)
          .push();

      await doneRef.set(GenericConverter.genericToJson<Model>(type, model));
      
      DatabaseEvent event = await doneRef.once();
      Model result =
          GenericConverter.genericFromDataSnapshot(type, event.snapshot, true);
      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[GenericRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }
}
import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/exercises/data/models/exercise_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

abstract class ExerciseRemoteDataSource {
  Future<ExerciseModel> addExercise(
      PatientModel patientModel, ExerciseModel exerciseModel);
  Future<void> deleteExercise(
      PatientModel patientModel, ExerciseModel exerciseModel);
  Future<ExerciseModel> editExerciseProfessional(
      ExerciseModel exerciseModel, PatientModel patientModel);
  Future<List<ExerciseModel>> getExerciseList(PatientModel patientModel);
  Future<ExerciseModel> executeExercise(
      ExerciseModel exerciseModel, PatientModel patientModel);
  Future<ExerciseModel> editExecutedExercise(
      ExerciseModel exerciseModel, PatientModel patientModel);
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final FirebaseDatabase firebaseDatabase;

  // 1. Centralizando as referências usando a instância injetada
  DatabaseReference get _patientRootRef => firebaseDatabase.ref('Patient');

  ExerciseRemoteDataSourceImpl({required this.firebaseDatabase});

  @override
  Future<ExerciseModel> addExercise(
      PatientModel patientModel, ExerciseModel exerciseModel) async {
    try {
      // 2. IDs podem ser nulos na Entidade, então usamos '!' após garantir que existem
      final String patientId = patientModel.id!;
      
      DatabaseReference exerciseRef = _patientRootRef
          .child(patientId)
          .child('ToDo')
          .child('Exercise')
          .push();

      await exerciseRef.set(exerciseModel.toJson());

      // 3. once() agora retorna DatabaseEvent
      DatabaseEvent event = await exerciseRef.once();
      return ExerciseModel.fromDataSnapshot(event.snapshot, false);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ExerciseRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<List<ExerciseModel>> getExerciseList(PatientModel patientModel) async {
    try {
      // 4. List<ExerciseModel>() não existe mais no Dart 3, usamos []
      List<ExerciseModel> result = [];
      final String patientId = patientModel.id!;

      // Buscando lista "A fazer"
      DatabaseReference refExerciseToDoList =
          _patientRootRef.child(patientId).child('ToDo').child('Exercise');
      DatabaseEvent toDoEvent = await refExerciseToDoList.once();
      result.addAll(ExerciseModel.fromDataSnapshotList(toDoEvent.snapshot, false));

      // Buscando lista "Realizados"
      DatabaseReference refExerciseDoneList =
          _patientRootRef.child(patientId).child('Done').child('Exercise');
      DatabaseEvent doneEvent = await refExerciseDoneList.once();
      result.addAll(ExerciseModel.fromDataSnapshotList(doneEvent.snapshot, true));

      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ExerciseRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ExerciseModel> editExerciseProfessional(
      ExerciseModel exerciseModel, PatientModel patientModel) async {
    try {
      final String patientId = patientModel.id!;
      final String exerciseId = exerciseModel.id!;

      var exerciseRef = _patientRootRef
          .child(patientId)
          .child('ToDo')
          .child('Exercise')
          .child(exerciseId);

      await exerciseRef.set(exerciseModel.toJson());
      
      DatabaseEvent event = await exerciseRef.once();
      return ExerciseModel.fromDataSnapshot(event.snapshot, false);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ExerciseRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ExerciseModel> executeExercise(
      ExerciseModel exerciseModel, PatientModel patientModel) async {
    try {
      final String patientId = patientModel.id!;

      DatabaseReference exerciseDoneRef = _patientRootRef
          .child(patientId)
          .child('Done')
          .child('Exercise')
          .push();
          
      await exerciseDoneRef.set(exerciseModel.toJson());

      DatabaseEvent event = await exerciseDoneRef.once();
      return ExerciseModel.fromDataSnapshot(event.snapshot, true);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ExerciseRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ExerciseModel> editExecutedExercise(
      ExerciseModel exerciseModel, PatientModel patientModel) async {
    try {
      final String patientId = patientModel.id!;
      final String exerciseId = exerciseModel.id!;

      DatabaseReference exerciseDoneRef = _patientRootRef
          .child(patientId)
          .child('Done')
          .child('Exercise')
          .child(exerciseId);     
               
      await exerciseDoneRef.set(exerciseModel.toJson());
      
      DatabaseEvent event = await exerciseDoneRef.once();
      return ExerciseModel.fromDataSnapshot(event.snapshot, true);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ExerciseRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<void> deleteExercise(PatientModel patientModel, ExerciseModel exerciseModel) async {
    try {
      final String patientId = patientModel.id!;
      final String exerciseId = exerciseModel.id!;

      String collection = exerciseModel.done ? 'Done' : 'ToDo';

      DatabaseReference exerciseRefDel = _patientRootRef
          .child(patientId)
          .child(collection)
          .child('Exercise')
          .child(exerciseId);

      await exerciseRefDel.remove();
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ExerciseRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  } 
}
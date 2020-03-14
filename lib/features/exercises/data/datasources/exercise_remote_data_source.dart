import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/exercises/data/models/exercise_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

abstract class ExerciseRemoteDataSource {
  Future<ExerciseModel> addExercise(
      PatientModel patientModel, ExerciseModel exerciseModel);
  Future<ExerciseModel> editExerciseProfessional(
      ExerciseModel exerciseModel, PatientModel patientModel);
  Future<List<ExerciseModel>> getExerciseList(PatientModel patientModel);
  Future<ExerciseModel> executeExercise(
      ExerciseModel exerciseModel, PatientModel patientModel);
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final FirebaseDatabase firebaseDatabase;
  final DatabaseReference patientRootRef =
      FirebaseDatabase.instance.reference().child('Patient');
  final DatabaseReference professionalRootRef =
      FirebaseDatabase.instance.reference().child('Professional');

  ExerciseRemoteDataSourceImpl({@required this.firebaseDatabase});

  @override
  Future<ExerciseModel> addExercise(
      PatientModel patientModel, ExerciseModel exerciseModel) async {
    try {
      DatabaseReference exerciseRef = patientRootRef
          .child(patientModel.id)
          .child('ToDo')
          .child('Exercise')
          .push();
      await exerciseRef.set(exerciseModel.toJson());
      DataSnapshot exerciseSnapshot = await exerciseRef.once();
      var result = ExerciseModel.fromDataSnapshot(exerciseSnapshot, false);

      return result;
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
      List<ExerciseModel> result = List<ExerciseModel>();

      DatabaseReference refExerciseToDoList =
          patientRootRef.child(patientModel.id).child('ToDo').child('Exercise');
      DataSnapshot exerciseToDoListSnapshot = await refExerciseToDoList.once();
      result.addAll(
          ExerciseModel.fromDataSnapshotList(exerciseToDoListSnapshot, false));

      DatabaseReference refExerciseDoneList =
          patientRootRef.child(patientModel.id).child('Done').child('Exercise');
      DataSnapshot exerciseDoneListSnapshot = await refExerciseDoneList.once();
      result.addAll(
          ExerciseModel.fromDataSnapshotList(exerciseDoneListSnapshot, true));

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
      var exerciseref = patientRootRef
          .child(patientModel.id)
          .child('ToDo')
          .child('Exercise')
          .child(exerciseModel.id);
      await exerciseref.set(exerciseModel.toJson());
      DataSnapshot exerciseSnapshot = await exerciseref.once();
      ExerciseModel result =
          ExerciseModel.fromDataSnapshot(exerciseSnapshot, false);
      return result;
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
      DatabaseReference exerciseDoneRef = patientRootRef
          .child(patientModel.id)
          .child('Done')
          .child('Exercise')
          .push();
      await exerciseDoneRef.set(exerciseModel.toJson());

      DataSnapshot exerciseSnapshot = await exerciseDoneRef.once();
      ExerciseModel result =
          ExerciseModel.fromDataSnapshot(exerciseSnapshot, true);
      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ExerciseRemoteDataSource] ${e.toString()}");
      throw ServerException();
    }
  }
}

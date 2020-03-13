import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/exercises/data/models/exercise_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

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

  ExerciseRemoteDataSourceImpl(this.firebaseDatabase);

  @override
  Future<ExerciseModel> addExercise(
      PatientModel patientModel, ExerciseModel exerciseModel) async {
    try {
      DatabaseReference patientRef =
          firebaseDatabase.reference().child('Patient').child(patientModel.id);
      patientRef.child('ToDo').child('Exercise').set(exerciseModel.toJson());
      DataSnapshot exerciseRef = await patientRef
          .child('ToDo')
          .child('Exercise')
          .child(exerciseModel.id)
          .once();
      var result = ExerciseModel.fromDataSnapshot(exerciseRef);

      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<List<ExerciseModel>> getExerciseList(PatientModel patientModel) async {
    try {
      var refExerciseList =
          patientRootRef.child(patientModel.id).child('ToDo').child('Exercise');
      List<ExerciseModel> result = List<ExerciseModel>();
      DataSnapshot exerciseListSnapshot = await refExerciseList.once();
      Map<dynamic, dynamic> objectMap =
          exerciseListSnapshot.value as Map<dynamic, dynamic>;
      if (objectMap != null) {
        for (MapEntry<dynamic, dynamic> entry in objectMap.entries) {
          var refExercise = patientRootRef
              .child(patientModel.id)
              .child('ToDo')
              .child('Exercise')
              .child(entry.key);
          DataSnapshot exerciseSnapshot = await refExercise.once();
          result.add(ExerciseModel.fromDataSnapshot(exerciseSnapshot));
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
      var result = ExerciseModel.fromDataSnapshot(exerciseSnapshot);
      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ExerciseModel> executeExercise(
      ExerciseModel exerciseModel, PatientModel patientModel) async {
    try {
      var _exerciseModel = await patientRootRef
          .child(patientModel.id)
          .child('ToDo')
          .child('Exercise')
          .child(exerciseModel.id)
          .once();
      var aux = ExerciseModel.fromDataSnapshot(_exerciseModel);
      var exerciseRef = patientRootRef
          .child(patientModel.id)
          .child('Done')
          .child('Exercise');
      await exerciseRef.set(aux.toJson());

      DataSnapshot exerciseSnapshot = await exerciseRef.child(aux.id).once();
      var result = ExerciseModel.fromDataSnapshot(exerciseSnapshot);
      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }
}

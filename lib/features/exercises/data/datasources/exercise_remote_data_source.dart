import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/exercises/data/models/exercise_model.dart';
import 'package:cardio_flutter/features/exercises/domain/usecases/edit_exercise_professional.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

abstract class ExerciseRemoreDataSource {
  Future<ExerciseModel> addExercise(PatientModel patientModel, ExerciseModel exerciseModel);
  Future<ExerciseModel> editExerciseProfessional(ExerciseModel  exerciseModel, PatientModel patientModel);
  Future<List<ExerciseModel>> checkExercise(PatientModel patientModel);
  Future<ExerciseModel> executeExercise(String exerciseId);
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoreDataSource {
  final FirebaseDatabase firebaseDatabase;
  final DatabaseReference patientRootRef =
      FirebaseDatabase.instance.reference().child('Patient');
  final DatabaseReference professionalRootRef =
      FirebaseDatabase.instance.reference().child('Professional');
      


  ExerciseRemoteDataSourceImpl(this.firebaseDatabase);

  @override
  Future<ExerciseModel> addExercise(PatientModel patientModel , ExerciseModel exerciseModel) async {
    DatabaseReference patientRef =
        firebaseDatabase.reference().child('Patient').child(patientModel.id);
    patientRef.child('ToDoActions').child('Exercise').set(exerciseModel.toJson());

    

    return null;
  }

  @override
  Future<List<ExerciseModel>> checkExercise(PatientModel patientModel) async{
   try  {var refExerciseList = patientRootRef.child(patientModel.id).child('Exercise');
    List<ExerciseModel> result = List<ExerciseModel>();
     DataSnapshot exerciseListSnapshot = await refExerciseList.once();
     Map<dynamic, dynamic> objectMap =
          exerciseListSnapshot.value as Map<dynamic, dynamic>;
         
         
          if (objectMap != null) {
        for (MapEntry<dynamic, dynamic> entry in objectMap.entries) {
          var refExercise = patientRootRef.child(patientModel.id).child('Exercise').child(entry.key);
          DataSnapshot exerciseSnapshot = await refExercise.once();
          result.add(ExerciseModel.fromDataSnapshot(exerciseSnapshot));
        }

      }
      return result;}
   on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[ManageProfessionalRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ExerciseModel> editExerciseProfessional(ExerciseModel exerciseModel, PatientModel patientModel)async {
    var exerciseref = patientRootRef.child(patientModel.id).child('Exercise').child(exerciseModel.id);
    await exerciseref.set(exerciseModel.toJson());
    DataSnapshot exerciseSnapshot = await exerciseref.once();
    return ExerciseModel.fromDataSnapshot(exerciseSnapshot);


    
  }


  @override
  Future<ExerciseModel> executeExercise(String exerciseId) {
    // TODO: implement executeExercise
    return null;
  }

  

 /*  @override
  Future<ExerciseModel> editExerciseProfessional(ExerciseModel exerciseModel, PatientModel patientModel) async{
    
    return null;
  } */
}

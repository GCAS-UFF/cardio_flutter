import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/data/models/professional_model.dart'; // Corrigido spelling
import 'package:cardio_flutter/features/auth/data/models/user_model.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

abstract class AuthRemoteDataSource {
  Future<dynamic> signIn(String email, String password);
  Future<UserModel> saveUser(UserModel userModel);
  Future<PatientModel> signUpPatient(
      String professionalId, PatientModel patientModel, String password);
  Future<ProfessionalModel> signUpProfessional(
      ProfessionalModel professionalModel, String password);
  Future<dynamic> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseDatabase,
  });

  @override
  Future<dynamic> signIn(String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      
      final String? uid = result.user?.uid;
      if (uid == null) throw ServerException();

      // Usamos uid! ou a variável já promovida
      DatabaseEvent event = await firebaseDatabase.ref().child('User').child(uid).once();
      DataSnapshot userSnapshot = event.snapshot;

      UserModel userModel = UserModel.fromDataSnapshot(userSnapshot);
      
      if (userModel.type == Keys.PATIENT_TYPE) {
        DatabaseEvent pEvent = await firebaseDatabase.ref().child('Patient').child(uid).once();
        return PatientModel.fromDataSnapshot(pEvent.snapshot);
      } else if (userModel.type == Keys.PROFESSIONAL_TYPE) {
        DatabaseEvent prEvent = await firebaseDatabase.ref().child('Professional').child(uid).once();
        return ProfessionalModel.fromDataSnapshot(prEvent.snapshot);
      } else {
        throw ServerException();
      }
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<PatientModel> signUpPatient(
      String professionalId, PatientModel patientModel, String password) async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: patientModel.email, password: password);
      
      final String? uid = result.user?.uid;
      if (uid == null) throw ServerException();

      // Aqui o uid já foi validado, usamos uid sem medo
      var ref = firebaseDatabase.ref().child('Patient').child(uid);
      await ref.set(patientModel.toJson());

      var refPatientList = firebaseDatabase
          .ref()
          .child('Professional')
          .child(professionalId)
          .child("PatientList");

      DatabaseEvent listEvent = await refPatientList.once();
      Map<dynamic, dynamic> patientListMap = {};

      if (listEvent.snapshot.value != null) {
        patientListMap.addAll(listEvent.snapshot.value as Map);
      }
      
      patientListMap[uid] = uid;
      await refPatientList.set(patientListMap);

      // Passamos uid (que agora é String e não String?)
      await saveUser(UserModel(
          id: uid, email: patientModel.email, type: Keys.PATIENT_TYPE));

      DatabaseEvent finalEvent = await ref.once();
      return PatientModel.fromDataSnapshot(finalEvent.snapshot);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ProfessionalModel> signUpProfessional(
      ProfessionalModel professionalModel, String password) async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: professionalModel.email, password: password);
      
      final String? uid = result.user?.uid;
      if (uid == null) throw ServerException();

      var prRef = firebaseDatabase.ref().child('Professional').child(uid);
      await prRef.set(professionalModel.toJson());

      await saveUser(UserModel(
          id: uid,
          email: professionalModel.email,
          type: Keys.PROFESSIONAL_TYPE));

      DatabaseEvent event = await prRef.once();
      return ProfessionalModel.fromDataSnapshot(event.snapshot);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> saveUser(UserModel userModel) async {
    try {
      // 1. O id do UserModel pode ser nulo (String?), mas o .child() exige String
      final String uid = userModel.id!; 
      
      var userRef = firebaseDatabase.ref().child('User').child(uid);
      await userRef.set(userModel.toJson());
      
      DatabaseEvent event = await userRef.once();
      return UserModel.fromDataSnapshot(event.snapshot);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<dynamic> getCurrentUser() async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user == null) throw UserNotCachedException();
      
      final String uid = user.uid; // Aqui user.uid é String garantida
      DatabaseEvent event = await firebaseDatabase.ref().child('User').child(uid).once();

      UserModel userModel = UserModel.fromDataSnapshot(event.snapshot);
      if (userModel.type == Keys.PATIENT_TYPE) {
        DatabaseEvent pEvent = await firebaseDatabase.ref().child('Patient').child(uid).once();
        return PatientModel.fromDataSnapshot(pEvent.snapshot);
      } else if (userModel.type == Keys.PROFESSIONAL_TYPE) {
        DatabaseEvent prEvent = await firebaseDatabase.ref().child('Professional').child(uid).once();
        return ProfessionalModel.fromDataSnapshot(prEvent.snapshot);
      } else {
        throw ServerException();
      }
    } on UserNotCachedException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }
}
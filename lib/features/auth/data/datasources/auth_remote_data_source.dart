import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/auth/data/models/profissional_model.dart';
import 'package:cardio_flutter/features/auth/data/models/user_model.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);

  Future<UserModel> saveUser(UserModel userModel);

  Future<UserModel> signUpPatient(
      String professionalId, PatientModel patientModel, String password);

  Future<UserModel> signUpProfessional(
      ProfessionalModel professionalModel, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;

  AuthRemoteDataSourceImpl(
      {@required this.firebaseAuth, @required this.firebaseDatabase});

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      String uid = result.user.uid;
      DataSnapshot userSnapshot = await FirebaseDatabase.instance
          .reference()
          .child('User')
          .child(uid)
          .once();

      return UserModel.fromDataSnapshot(userSnapshot);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[AuthRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUpPatient(
      String professionalId, PatientModel patientModel, String password) async {
    // Withou professional we cant save patients
    if (professionalId == null) throw ServerException();
    try {
      // Make sign up
      AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(
          email: patientModel.email, password: password);
      // Get user id
      String uid = result.user.uid;
      // Get patient reference in firebase
      var ref =
          FirebaseDatabase.instance.reference().child('Patient').child(uid);
      // Save patient into firebase
      await ref.set(patientModel.toJson());
      // Get patient reference inside professional colection
      var refPatientList = FirebaseDatabase.instance
          .reference()
          .child('Professional')
          .child(professionalId)
          .child("PatientList");
      // Save patient reference inside professional colection
      DataSnapshot patientListSnapshot = await refPatientList.once();
      Map<dynamic, dynamic> patientListMap = patientListSnapshot.value;
      patientListMap[uid] = uid;
      await refPatientList.set(patientListMap);
      // Save user into firebase and return
      return await saveUser(UserModel(
          id: uid, email: patientModel.email, type: Keys.PATIENT_TYPE));
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[AuthRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUpProfessional(
      ProfessionalModel professionalModel, String password) async {
    try {
      // Make sign up
      AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(
          email: professionalModel.email, password: password);
      // Get user id
      String uid = result.user.uid;
      // Get professional reference in firebase
      var ref = FirebaseDatabase.instance
          .reference()
          .child('Professional')
          .child(uid);
      // Save professional into firebase
      await ref.set(professionalModel.toJson());
      // Save user into firebase and return
      return await saveUser(UserModel(
          id: uid,
          email: professionalModel.email,
          type: Keys.PROFESSIONAL_TYPE));
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[AuthRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<UserModel> saveUser(UserModel userModel) async {
    try {
      // Get user reference
      var userRef = FirebaseDatabase.instance
          .reference()
          .child('User')
          .child(userModel.id);
      // Save user into firebase
      await userRef.set(userModel.toJson());
      // Get user from firebase
      DataSnapshot userSnapshot = await userRef.once();
      return UserModel.fromDataSnapshot(userSnapshot);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[AuthRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }
}

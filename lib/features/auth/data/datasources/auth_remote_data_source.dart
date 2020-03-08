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

  Future<void> saveUser(UserModel userModel);

  Future<PatientModel> signUpPatient(
      PatientModel patientModel, String password);

  Future<ProfessionalModel> signUpProfessional(
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
  Future<PatientModel> signUpPatient(
      PatientModel patientModel, String password) async {
    try {
      // Make sign up
      AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(
          email: patientModel.email, password: password);
      // Get user id
      String uid = result.user.uid;
      // Save user into firebase
      await saveUser(UserModel(
          id: uid, email: patientModel.email, type: Keys.PATIENT_TYPE));
      // Get patient reference in firebase
      var ref =
          FirebaseDatabase.instance.reference().child('Patient').child(uid);
      // Save patient into firebase
      await ref.set(patientModel.toJson());
      // Get patient from reference and return
      DataSnapshot patientSnapshot = await ref.once();
      return PatientModel.fromDataSnapshot(patientSnapshot);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[AuthRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<ProfessionalModel> signUpProfessional(
      ProfessionalModel professionalModel, String password) async {
    try {
      // Make sign up
      AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(
          email: professionalModel.email, password: password);
      // Get user id
      String uid = result.user.uid;
      // Save user into firebase
      await saveUser(UserModel(
          id: uid,
          email: professionalModel.email,
          type: Keys.PROFESSIONAL_TYPE));
      // Get professional reference in firebase
      var ref = FirebaseDatabase.instance
          .reference()
          .child('Professional')
          .child(uid);
      // Save professional into firebase
      await ref.set(professionalModel.toJson());
      // Get professional from reference and return
      DataSnapshot professionalSnapshot = await ref.once();
      return ProfessionalModel.fromDataSnapshot(professionalSnapshot);
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[AuthRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<void> saveUser(UserModel userModel) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('User')
          .child(userModel.id)
          .set(userModel.toJson());
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[AuthRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }
}

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
  Future<dynamic> signIn(String email, String password);

  Future<UserModel> saveUser(UserModel userModel);

  Future<PatientModel> signUpPatient(String professionalId, PatientModel patientModel, String password);

  Future<ProfessionalModel> signUpProfessional(ProfessionalModel professionalModel, String password);

  Future<dynamic> getCurrentUser();

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;

  AuthRemoteDataSourceImpl({@required this.firebaseAuth, @required this.firebaseDatabase});

  @override
  Future<dynamic> signIn(String email, String password) async {
    try {
      AuthResult result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      String uid = result.user.uid;
      DataSnapshot userSnapshot = await FirebaseDatabase.instance.reference().child('User').child(uid).once();

      UserModel userModel = UserModel.fromDataSnapshot(userSnapshot);
      if (userModel.type == Keys.PATIENT_TYPE) {
        var ref = FirebaseDatabase.instance.reference().child('Patient').child(uid);
        DataSnapshot patientSnapshot = await ref.once();
        return PatientModel.fromDataSnapshot(patientSnapshot);
      } else if (userModel.type == Keys.PROFESSIONAL_TYPE) {
        var ref = FirebaseDatabase.instance.reference().child('Professional').child(uid);
        DataSnapshot professionalSnapshot = await ref.once();
        return ProfessionalModel.fromDataSnapshot(professionalSnapshot);
      } else {
        throw ServerException();
      }
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[AuthRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<PatientModel> signUpPatient(String professionalId, PatientModel patientModel, String password) async {
    // Withou professional we cant save patients
    if (professionalId == null) throw ServerException();
    try {
      // Make sign up
      AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(email: patientModel.email, password: password);
      // Get user id
      String uid = result.user.uid;
      // Get patient reference in firebase
      var ref = FirebaseDatabase.instance.reference().child('Patient').child(uid);
      // Save patient into firebase
      await ref.set(patientModel.toJson());
      // Get patient reference inside professional colection
      var refPatientList = FirebaseDatabase.instance.reference().child('Professional').child(professionalId).child("PatientList");
      // Save patient reference inside professional colection
      DataSnapshot patientListSnapshot = await refPatientList.once();
      Map<dynamic, dynamic> patientListMap = Map<dynamic, dynamic>();
      if (patientListSnapshot.value != null) patientListMap.addAll(patientListSnapshot.value);
      patientListMap[uid] = uid;
      await refPatientList.set(patientListMap);
      // Save user into firebase
      await saveUser(UserModel(id: uid, email: patientModel.email, type: Keys.PATIENT_TYPE));
      // Get patient from database
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
  Future<ProfessionalModel> signUpProfessional(ProfessionalModel professionalModel, String password) async {
    try {
      // Make sign up
      AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(email: professionalModel.email, password: password);
      // Get user id
      String uid = result.user.uid;
      // Get professional reference in firebase
      var ref = FirebaseDatabase.instance.reference().child('Professional').child(uid);
      // Save professional into firebase
      await ref.set(professionalModel.toJson());
      // Save user into firebase
      await saveUser(UserModel(id: uid, email: professionalModel.email, type: Keys.PROFESSIONAL_TYPE));
      // Get professional from database
      DataSnapshot professionalsnapshot = await ref.once();
      return ProfessionalModel.fromDataSnapshot(professionalsnapshot);
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
      var userRef = FirebaseDatabase.instance.reference().child('User').child(userModel.id);
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

  @override
  Future<dynamic> getCurrentUser() async {
    try {
      FirebaseUser user = await firebaseAuth.currentUser();
      if (user == null) throw UserNotCachedException();
      String uid = user.uid;
      DataSnapshot userSnapshot = await FirebaseDatabase.instance.reference().child('User').child(uid).once();

      UserModel userModel = UserModel.fromDataSnapshot(userSnapshot);
      if (userModel.type == Keys.PATIENT_TYPE) {
        var ref = FirebaseDatabase.instance.reference().child('Patient').child(uid);
        DataSnapshot patientSnapshot = await ref.once();
        return PatientModel.fromDataSnapshot(patientSnapshot);
      } else if (userModel.type == Keys.PROFESSIONAL_TYPE) {
        var ref = FirebaseDatabase.instance.reference().child('Professional').child(uid);
        DataSnapshot professionalSnapshot = await ref.once();
        return ProfessionalModel.fromDataSnapshot(professionalSnapshot);
      } else {
        throw ServerException();
      }
    } on PlatformException catch (e) {
      throw e;
    } on UserNotCachedException catch (e) {
      throw e;
    } catch (e) {
      print("[AuthRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() {
    try {
      return firebaseAuth.signOut();
    } catch (e) {
      throw e;
    }
  }
}

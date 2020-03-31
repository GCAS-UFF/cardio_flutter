import 'package:cardio_flutter/features/auth/data/models/patient_model.dart';
import 'package:cardio_flutter/features/generic_feature/util/generic_converter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cardio_flutter/core/error/exception.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

abstract class GenericRemoteDataSource<Model> {
  Future<Model> addRecomendation(PatientModel patientModel, Model model);
}

class GenericRemoteDataSourceImpl<Model>
    implements GenericRemoteDataSource<Model> {
  final FirebaseDatabase firebaseDatabase;
  final String firebaseTag;
  final String type;

  final DatabaseReference patientRootRef =
      FirebaseDatabase.instance.reference().child('Patient');

  GenericRemoteDataSourceImpl(
      {@required this.firebaseDatabase,
      @required this.firebaseTag,
      @required this.type});

  @override
  Future<Model> addRecomendation(PatientModel patientModel, Model model) async {
    try {
      DatabaseReference recomendaionRef = patientRootRef
          .child(patientModel.id)
          .child('ToDo')
          .child(firebaseTag)
          .push();
      await recomendaionRef
          .set(GenericConverter.genericToJson<Model>(type, model));
      DataSnapshot recomendationSnapshot = await recomendaionRef.once();
      var result =
          GenericConverter.genericFromDataSnapshot(type, recomendationSnapshot);

      return result;
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      print("[GenericRemoteDataSourceImpl] ${e.toString()}");
      throw ServerException();
    }
  }
}

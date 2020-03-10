import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class PatientModel extends Patient {
  PatientModel({
    @required id,
    @required name,
    @required cpf,
    @required address,
    @required birthdate,
    @required email,
  }) : super(
            id: id,
            name: name,
            cpf: cpf,
            birthdate: birthdate,
            address: address,
            email: email);

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> json = {};
    if (id != null) json['id'] = id;
    if (name != null) json['name'] = name;
    if (cpf != null) json['cpf'] = cpf;
    if (address != null) json['address'] = address;
    if (birthdate != null) json['birthdate'] = birthdate.millisecondsSinceEpoch;
    if (email != null) json['email'] = email;

    return json;
  }

  factory PatientModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return PatientModel(
      id: json['id'],
      name: json['name'],
      cpf: json['cpf'],
      birthdate: (json['birthdate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['birthdate']),
      address: json['address'],
      email: json['email'],
    );
  }

  factory PatientModel.fromEntity(Patient patient) {
    if (patient == null) return null;
    return PatientModel(
      id: patient.id,
      name: patient.name,
      address: patient.address,
      email: patient.email,
      cpf: patient.cpf,
      birthdate: patient.birthdate,
    );
  }

  factory PatientModel.fromDataSnapshot(DataSnapshot dataSnapshot) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;

    return PatientModel.fromJson(objectMap);
  }
}

import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class ProfessionalModel extends Professional {
  ProfessionalModel(
      {@required id,
      @required name,
      @required cpf,
      @required regionalRecord,
      @required expertise,
      @required email})
      : super(
            id: id,
            name: name,
            cpf: cpf,
            regionalRecord: regionalRecord,
            expertise: expertise,
            email: email);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (id != null) json['id'] = id;
    if (name != null) json['name'] = name;
    if (cpf != null) json['cpf'] = cpf;
    if (regionalRecord != null) json['regionalRecord'] = regionalRecord;
    if (expertise != null) json['expertise'] = expertise;
    if (email != null) json['email'] = email;

    return json;
  }

  factory ProfessionalModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return ProfessionalModel(
      id: json['id'],
      name: json['name'],
      cpf: json['cpf'],
      regionalRecord: json['regionalRecord'],
      expertise: json['expertise'],
      email: json['email'],
    );
  }

  factory ProfessionalModel.fromEntity(Professional professional) {
    if (professional == null) return null;
    return ProfessionalModel(
      id: professional.id,
      name: professional.name,
      cpf: professional.cpf,
      email: professional.email,
      expertise: professional.expertise,
      regionalRecord: professional.regionalRecord,
    );
  }

  factory ProfessionalModel.fromDataSnapshot(DataSnapshot dataSnapshot) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;

    return ProfessionalModel.fromJson(objectMap);
  }
}

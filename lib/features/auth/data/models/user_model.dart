import 'package:cardio_flutter/features/auth/domain/entities/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class UserModel extends User {
  UserModel({@required id, @required email, @required type})
      : super(id: id, email: email, type: type);

  Map<dynamic, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (id != null) json['id'] = id;
    if (email != null) json['email'] = email;
    if (type != null) json['type'] = type;

    return json;
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return UserModel(
      id: json['id'],
      email: json['email'],
      type: json['type'],
    );
  }

  factory UserModel.fromEntity(User user) {
    if (user == null) return null;
    return UserModel(id: user.id, email: user.email, type: user.type);
  }

  factory UserModel.fromDataSnapshot(DataSnapshot dataSnapshot) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;

    return UserModel.fromJson(objectMap);
  }
}

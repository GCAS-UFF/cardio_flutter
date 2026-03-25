import 'package:cardio_flutter/features/auth/domain/entities/user.dart';
import 'package:firebase_database/firebase_database.dart';

class UserModel extends User {
  UserModel({
    required super.id, 
    required super.email, 
    required super.type,
  });

  // 1. toJson limpo: Se os campos são obrigatórios, não precisamos de 'if != null'
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'type': type,
    };
  }

  // 2. factory não pode retornar null. Usamos valores padrão ou lançamos erro.
  factory UserModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) throw Exception("JSON de usuário nulo");
    
    return UserModel(
      id: json['id'] ?? "",
      email: json['email'] ?? "",
      type: json['type'] ?? "",
    );
  }

  // 3. Mudado para static para permitir o retorno nulo se a entidade for nula
  static UserModel? fromEntity(User? user) {
    if (user == null) return null;
    return UserModel(id: user.id, email: user.email, type: user.type);
  }

  // 4. Tratamento do DataSnapshot atualizado para o Firebase moderno
  factory UserModel.fromDataSnapshot(DataSnapshot dataSnapshot) {
    final value = dataSnapshot.value;
    if (value == null) throw Exception("Snapshot de usuário vazio");

    // Convertendo Object? para Map
    final Map<dynamic, dynamic> objectMap = Map<dynamic, dynamic>.from(value as Map);

    // Injetando o ID que vem da chave do nó
    objectMap['id'] = dataSnapshot.key;

    return UserModel.fromJson(objectMap);
  }
}
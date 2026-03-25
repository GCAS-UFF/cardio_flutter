import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:firebase_database/firebase_database.dart';

class PatientModel extends Patient {
  PatientModel({
    required super.id,
    required super.name,
    required super.cpf,
    required super.address,
    required super.birthdate,
    required super.email,
  });

  // 1. toJson simplificado: sem checagens redundantes de nulo para campos obrigatórios
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'address': address,
      'birthdate': birthdate.millisecondsSinceEpoch,
      'email': email,
    };
  }

  // 2. factory não pode retornar null. Usamos valores padrão ou lançamos erro.
  factory PatientModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) throw Exception("JSON de paciente é nulo");

    return PatientModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      cpf: json['cpf'] ?? "",
      address: json['address'] ?? "",
      birthdate: (json['birthdate'] == null)
          ? DateTime.now() // Ou outro fallback que faça sentido na sua regra
          : DateTime.fromMillisecondsSinceEpoch(json['birthdate']),
      email: json['email'] ?? "",
    );
  }

  // 3. Mudado para static para permitir o retorno nulo opcional
  static PatientModel? fromEntity(Patient? patient) {
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

  // 4. Lógica de extração do valor do DataSnapshot atualizada
  factory PatientModel.fromDataSnapshot(DataSnapshot dataSnapshot) {
    final value = dataSnapshot.value;
    if (value == null) throw Exception("Snapshot vazio");

    // Convertendo Object? para Map
    final Map<dynamic, dynamic> objectMap = Map<dynamic, dynamic>.from(value as Map);

    // Injetando a chave do nó como ID
    objectMap['id'] = dataSnapshot.key;

    return PatientModel.fromJson(objectMap);
  }
}
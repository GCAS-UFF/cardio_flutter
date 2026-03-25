import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfessionalModel extends Professional {
  ProfessionalModel({
    required super.id,
    required super.name,
    required super.cpf,
    required super.regionalRecord,
    required super.expertise,
    required super.email,
  });

  // 1. toJson limpo: Se os campos são obrigatórios, não precisamos de 'if != null'
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'regionalRecord': regionalRecord,
      'expertise': expertise,
      'email': email,
    };
  }

  // 2. O construtor factory não pode retornar null.
  // Usamos valores padrão (?? "") para garantir que o objeto seja criado.
  factory ProfessionalModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) throw Exception("Dados do Profissional nulos no JSON");
    
    return ProfessionalModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      cpf: json['cpf'] ?? "",
      regionalRecord: json['regionalRecord'] ?? "",
      expertise: json['expertise'] ?? "",
      email: json['email'] ?? "",
    );
  }

  // 3. Mudamos para um método estático para permitir retorno nulo se a entidade for nula
  static ProfessionalModel? fromEntity(Professional? professional) {
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

  // 4. Tratamento correto do DataSnapshot para o Firebase moderno
  factory ProfessionalModel.fromDataSnapshot(DataSnapshot dataSnapshot) {
    final value = dataSnapshot.value;
    if (value == null) throw Exception("Snapshot do Firebase vazio");

    // Fazemos o cast do Object? para Map
    final Map<dynamic, dynamic> objectMap = Map<dynamic, dynamic>.from(value as Map);

    // Injetamos o ID que vem da chave do snapshot
    objectMap['id'] = dataSnapshot.key;

    return ProfessionalModel.fromJson(objectMap);
  }
}
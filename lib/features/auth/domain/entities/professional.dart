import 'package:equatable/equatable.dart';

class Professional extends Equatable {
  final String? id;
  final String name;
  final String cpf;
  final String regionalRecord;
  final String expertise;
  final String email;

  const Professional({
    this.id,
    required this.name,
    required this.cpf,
    required this.regionalRecord,
    required this.expertise,
    required this.email, // 1. Agora o email é obrigatório
  });

  @override
  // 2. Mudamos para List<Object?> para incluir o 'id' com segurança
  List<Object?> get props => [id, name, cpf, regionalRecord, expertise, email];
}
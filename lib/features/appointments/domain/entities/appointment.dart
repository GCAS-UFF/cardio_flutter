import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';

class Appointment extends BaseEntity {
  final DateTime appointmentDate;
  final String address; // Corrigido de 'adress' para 'address'
  final String expertise;
  final String? justification; // 1. Coloquei '?' pois justificativa pode ser nula
  final bool? went; // 2. '?' pois antes da consulta você ainda não sabe se foi

  Appointment({
    // 3. Usando a sintaxe 'super.id' (se o seu BaseEntity permitir) ou tipando
    dynamic id,
    DateTime? executedDate,
    bool done = false,
    this.justification,
    this.went,
    required this.appointmentDate,
    required this.address,
    required this.expertise,
  }) : super(
            id: id,
            initialDate: appointmentDate,
            finalDate: appointmentDate,
            executedDate: executedDate,
            done: done);

  @override
  // 4. List<Object?> permite que os campos nulos entrem na comparação do Equatable
  List<Object?> get props => [
        address,
        expertise,
        appointmentDate,
        went,
        id,
        done,
        executedDate,
        justification,
      ];
}
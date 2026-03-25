import 'package:equatable/equatable.dart';

abstract class BaseEntity extends Equatable {
  final String? id;
  final DateTime initialDate; // Sem o '?', é obrigatório
  final DateTime finalDate;   // Sem o '?', é obrigatório
  final DateTime? executedDate;
  final bool done;

  const BaseEntity({
    this.id,
    required this.initialDate, // Adicionado 'required'
    required this.finalDate,   // Adicionado 'required'
    this.executedDate,
    required this.done,
  });

  @override
  List<Object?> get props => [id, initialDate, finalDate, executedDate, done];
}
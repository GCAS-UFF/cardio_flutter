import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id; // 1. Opcional, pois pode não existir antes de salvar
  final String email;
  final String type;

  // 2. Trocamos @required pelo required nativo e id como opcional
  const User({
    this.id, 
    required this.email, 
    required this.type,
  });

  @override
  // 3. List<Object?> permite que o Equatable lide com o id sendo nulo
  List<Object?> get props => [id, email, type];
}
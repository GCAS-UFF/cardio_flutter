import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Professional extends Equatable {
  final String id;
  final String name;
  final String cpf;
  final String regionalRecord;
  final String expertise;
  final String email;

  Professional(
      {this.id,
      @required this.name,
      @required this.cpf,
      @required this.regionalRecord,
      @required this.expertise,
      @required this.email});

  @override
  List<Object> get props => [name, cpf, regionalRecord, expertise, email];
}

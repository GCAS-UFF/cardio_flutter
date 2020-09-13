import 'package:cardio_flutter/features/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Patient extends Equatable implements User {
  final String id;
  final String name;
  final String cpf;
  final String address;
  final DateTime birthdate;
  final String email;

  Patient(
      {this.id,
      @required this.name,
      @required this.cpf,
      @required this.address,
      @required this.birthdate,
      @required this.email});

  @override
  List<Object> get props => [name, cpf, address, birthdate, email];

  @override
  String get type => "PATIENT";
}

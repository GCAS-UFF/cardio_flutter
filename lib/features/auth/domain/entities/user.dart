import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String type;

  User({this.id, @required this.email, @required this.type});

  @override
  List<Object> get props => [email, type];
}

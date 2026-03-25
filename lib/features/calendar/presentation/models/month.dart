import 'package:cardio_flutter/features/calendar/presentation/models/day.dart';
import 'package:equatable/equatable.dart';

class Month extends Equatable {
  final int year;
  final int id;
  final List<Day> days;

  Month({required this.year, required this.days, required this.id});

  @override
  List<Object> get props => [year, days];
}
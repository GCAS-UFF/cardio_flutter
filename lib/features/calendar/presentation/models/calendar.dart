import 'package:cardio_flutter/features/calendar/presentation/models/month.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Calendar extends Equatable {
  final List<Month> months;

  Calendar({@required this.months});

  @override
  List<Object> get props => months;
  
}
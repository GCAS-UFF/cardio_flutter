import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Day extends Equatable{
  final List<Activity> activities;
  final int id;

  Day({@required this.activities, @required this.id});

  @override
  List<Object> get props => [activities];
}
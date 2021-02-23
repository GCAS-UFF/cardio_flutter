import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Exercise extends BaseEntity {
  final String name;
  final int frequency;
  // final int frequencyPerWeek;
  final String intensity;
  final int durationInMinutes;
  final List<String> times;
  final String observation;
  final bool shortnessOfBreath;
  final bool excessiveFatigue;
  final bool dizziness;
  final bool bodyPain;

  Exercise({
    id,
    this.observation,
    this.times,
    this.shortnessOfBreath,
    this.excessiveFatigue,
    // this.frequencyPerWeek,
    this.dizziness,
    this.bodyPain,
    @required this.name,
    this.frequency,
    @required this.intensity,
    @required this.durationInMinutes,
    initialDate,
    finalDate,
    executedDate,
    @required done,
  }) : super(
          initialDate: initialDate,
          finalDate: finalDate,
          executedDate: executedDate,
          id: id,
          done: done,
        );

  @override
  List<Object> get props => [
        shortnessOfBreath,
        observation,
        excessiveFatigue,
        dizziness,
        // frequencyPerWeek,
        bodyPain,
        name,
        times,
        frequency,
        intensity,
        durationInMinutes,
        initialDate,
        finalDate,
        executedDate,
        id,
        done,
      ];
}

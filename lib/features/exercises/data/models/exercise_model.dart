import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ExerciseModel extends Exercise {
  ExerciseModel(
      { DateTime timeOfDay,
       String id,
       bool shortnessOfBreath,
       bool excessiveFatigue,
       bool dizziness,
       bool bodyPain,
      @required String name,
      @required int frequency,
      @required String intensity,
      @required int durationInMinutes,
      @required DateTime inicialDate,
      @required DateTime finalDate})
      : super(
          timeOfDay: timeOfDay,
          id: id,
          shortnessOfBreath: shortnessOfBreath,
          excessiveFatigue: excessiveFatigue,
          dizziness: dizziness,
          bodyPain: bodyPain,
          name: name,
          frequency: frequency,
          intensity: intensity,
          durationInMinutes: durationInMinutes,
          inicialDate: inicialDate,
          finalDate: finalDate,
        );

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> json = {};
    if (timeOfDay != null) json['timeOfDay'] = timeOfDay.millisecondsSinceEpoch;
    if (inicialDate != null)
      json['inicialDate'] = inicialDate.millisecondsSinceEpoch;
    if (finalDate != null) json['finalDate'] = finalDate.millisecondsSinceEpoch;
    if (name != null) json['name'] = name;
    if (id != null) json['id'] = id;
    if (frequency != null) json['frequency'] = frequency;
    if (intensity != null) json['intensity'] = intensity;
    if (durationInMinutes != null)
      json['durationInMinutes'] = durationInMinutes;
    if (excessiveFatigue != null) json['excessiveFatigue'] = excessiveFatigue;
    if (shortnessOfBreath != null)
      json['shortnessOfBreath'] = shortnessOfBreath;
    if (dizziness != null) json['dizziness'] = dizziness;
    if (bodyPain != null) json['bodyPain'] = bodyPain;

    return json;
  }

  factory ExerciseModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;
    return ExerciseModel(
      timeOfDay: (json['timeOfDay'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['timeOfDay']),
      inicialDate: (json['inicialDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['inicialDate']),
      finalDate: (json['finalDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      id: json['id'],
      name: json['name'],
      frequency: json['frequency'],
      intensity: json['intensity'],
      durationInMinutes: json['durationInMinutes'],
      shortnessOfBreath: json['shortnessOfBreath'],
      excessiveFatigue: json['excessiveFatigue'],
      dizziness: json['dizziness'],
      bodyPain: json['bodyPain'],
    );
  }

  factory ExerciseModel.fromEntity(Exercise exercise) {
    if (exercise == null) return null;
    return ExerciseModel(
      name: exercise.name,
      bodyPain: exercise.bodyPain,
      dizziness: exercise.dizziness,
      durationInMinutes: exercise.durationInMinutes,
      excessiveFatigue: exercise.excessiveFatigue,
      id: exercise.id,
      finalDate: exercise.finalDate,
      frequency: exercise.frequency,
      inicialDate: exercise.inicialDate,
      intensity: exercise.intensity,
      shortnessOfBreath: exercise.shortnessOfBreath,
      timeOfDay: exercise.timeOfDay,
    );
  }

  factory ExerciseModel.fromDataSnapshot(DataSnapshot dataSnapshot) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;

    return ExerciseModel.fromJson(objectMap);
  }
}

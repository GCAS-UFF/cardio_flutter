import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ExerciseModel extends Exercise {
  ExerciseModel({
    @required DateTime executionDay,
    @required String id,
    @required List<String> symptoms,
    @required bool shortnessOfBreath,
    @required bool excessiveFatigue,
    @required bool dizziness,
    @required bool bodyPain,
    @required List<String> times,
    @required String executionTime,
    @required String observation,
    @required String name,
    @required int frequency,
    @required String intensity,
    @required int durationInMinutes,
    @required DateTime initialDate,
    @required DateTime finalDate,
    @required bool done,
  }) : super(
          executionDay: executionDay,
          id: id,
          symptoms: symptoms,
          shortnessOfBreath: shortnessOfBreath,
          excessiveFatigue: excessiveFatigue,
          dizziness: dizziness,
          bodyPain: bodyPain,
          name: name,
          frequency: frequency,
          times: times,
          observation: observation,
          intensity: intensity,
          durationInMinutes: durationInMinutes,
          initialDate: initialDate,
          finalDate: finalDate,
          done: done,
          executionTime: executionTime,
        );

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> json = {};
    if (executionDay != null)
      json['executionDay'] = executionDay.millisecondsSinceEpoch;
    if (initialDate != null)
      json['initialDate'] = initialDate.millisecondsSinceEpoch;
    if (finalDate != null) json['finalDate'] = finalDate.millisecondsSinceEpoch;
    if (name != null) json['name'] = name;
    if (frequency != null) json['frequency'] = frequency;
    if (intensity != null) json['intensity'] = intensity;
    if (durationInMinutes != null)
      json['durationInMinutes'] = durationInMinutes;
    if (excessiveFatigue != null) json['excessiveFatigue'] = excessiveFatigue;
    if (shortnessOfBreath != null)
      json['shortnessOfBreath'] = shortnessOfBreath;
    if (dizziness != null) json['dizziness'] = dizziness;
    if (bodyPain != null) json['bodyPain'] = bodyPain;
    if (executionTime != null) json['executionTime'] = executionTime;
    if (times != null) json['times'] = times;
    if (observation != null) json['observation'] = observation;

    return json;
  }

  factory ExerciseModel.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return null;

    List<String> _symptomsList = [];
    if (json['shortnessOfBreath'] != null && json['shortnessOfBreath'] == true)
      _symptomsList.add("Falta de ar");
    if (json['excessiveFatigue'] != null && json['excessiveFatigue'])
      _symptomsList.add("Fadiga excessiva");
    if (json['dizziness'] != null && json['dizziness'])
      _symptomsList.add("Tontura");
    if (json['bodyPain'] != null && json['bodyPain'])
      _symptomsList.add("Dores corporais");

    return ExerciseModel(
      executionDay: (json['executionDay'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executionDay']),
      initialDate: (json['initialDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      id: json['id'],
      name: json['name'],
      frequency: json['frequency'],
      intensity: json['intensity'],
      durationInMinutes: json['durationInMinutes'],
      symptoms: _symptomsList,
      shortnessOfBreath: json['shortnessOfBreath'],
      excessiveFatigue: json['excessiveFatigue'],
      dizziness: json['dizziness'],
      bodyPain: json['bodyPain'],
      done: json['done'],
      executionTime: json['executionTime'],
      times: Converter.convertListDynamicToListString(json['times']),
      observation: json['observation'],
    );
  }

  factory ExerciseModel.fromEntity(Exercise exercise) {
    if (exercise == null) return null;

    List<String> _symptomsList = [];
    if (exercise.shortnessOfBreath != null && exercise.shortnessOfBreath)
      _symptomsList.add("Falta de ar");
    if (exercise.excessiveFatigue != null && exercise.excessiveFatigue)
      _symptomsList.add("Fadiga excessiva");
    if (exercise.dizziness != null && exercise.dizziness)
      _symptomsList.add("Tontura");
    if (exercise.bodyPain != null && exercise.bodyPain)
      _symptomsList.add("Dores corporais");

    return ExerciseModel(
      name: exercise.name,
      symptoms: _symptomsList,
      bodyPain: exercise.bodyPain,
      dizziness: exercise.dizziness,
      durationInMinutes: exercise.durationInMinutes,
      excessiveFatigue: exercise.excessiveFatigue,
      id: exercise.id,
      finalDate: exercise.finalDate,
      frequency: exercise.frequency,
      initialDate: exercise.initialDate,
      intensity: exercise.intensity,
      shortnessOfBreath: exercise.shortnessOfBreath,
      executionDay: exercise.executionDay,
      done: exercise.done,
      executionTime: exercise.executionTime,
      times: exercise.times,
      observation: exercise.observation,
    );
  }

  factory ExerciseModel.fromDataSnapshot(DataSnapshot dataSnapshot, bool done) {
    if (dataSnapshot == null) return null;

    Map<dynamic, dynamic> objectMap =
        dataSnapshot.value as Map<dynamic, dynamic>;

    objectMap['id'] = dataSnapshot.key;
    objectMap['done'] = done;

    return ExerciseModel.fromJson(objectMap);
  }

  static List<ExerciseModel> fromDataSnapshotList(
      DataSnapshot dataSnapshot, bool done) {
    if (dataSnapshot == null) return null;

    List<ExerciseModel> result = List<ExerciseModel>();
    Map<dynamic, dynamic> objectTodoMap =
        dataSnapshot.value as Map<dynamic, dynamic>;
    if (objectTodoMap != null) {
      for (MapEntry<dynamic, dynamic> entry in objectTodoMap.entries) {
        Map<dynamic, dynamic> exerciseMap = entry.value;
        exerciseMap['id'] = entry.key;
        exerciseMap['done'] = done;
        print(exerciseMap);
        result.add(ExerciseModel.fromJson(exerciseMap));
      }
    }

    return result;
  }
}

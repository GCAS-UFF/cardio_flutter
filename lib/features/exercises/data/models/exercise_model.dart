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
    @required int frequencyPerWeek,
    @required String intensity,
    @required int durationInMinutes,
    @required DateTime initialDate,
    @required DateTime finalDate,
    @required DateTime executedDate,
    @required bool done,
  }) : super(
          executedDate: executedDate,
          id: id,
          symptoms: symptoms,
          shortnessOfBreath: shortnessOfBreath,
          excessiveFatigue: excessiveFatigue,
          dizziness: dizziness,
          bodyPain: bodyPain,
          name: name,
          frequency: frequency,
          frequencyPerWeek: frequencyPerWeek,
          times: times,
          observation: observation,
          intensity: intensity,
          durationInMinutes: durationInMinutes,
          initialDate: initialDate,
          finalDate: finalDate,
          done: done,
        );

  static Map<dynamic, dynamic> toJson(ExerciseModel model) {
    Map<dynamic, dynamic> json = {};
    if (model.executedDate != null)
      json['executedDate'] = model.executedDate.millisecondsSinceEpoch;
    if (model.initialDate != null)
      json['initialDate'] = model.initialDate.millisecondsSinceEpoch;
    if (model.finalDate != null)
      json['finalDate'] = model.finalDate.millisecondsSinceEpoch;
    if (model.name != null) json['name'] = model.name;
    if (model.frequency != null) json['frequency'] = model.frequency;
    if (model.frequency != null)
      json['frequencyPerWeek'] = model.frequencyPerWeek;
    if (model.intensity != null) json['intensity'] = model.intensity;
    if (model.durationInMinutes != null)
      json['durationInMinutes'] = model.durationInMinutes;
    if (model.excessiveFatigue != null)
      json['excessiveFatigue'] = model.excessiveFatigue;
    if (model.shortnessOfBreath != null)
      json['shortnessOfBreath'] = model.shortnessOfBreath;
    if (model.dizziness != null) json['dizziness'] = model.dizziness;
    if (model.bodyPain != null) json['bodyPain'] = model.bodyPain;
    if (model.executedDate != null) json['executionTime'] = model.executedDate;
    if (model.times != null) json['times'] = model.times;
    if (model.observation != null) json['observation'] = model.observation;

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
      executedDate: (json['executedDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['executedDate']),
      initialDate: (json['initialDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      id: json['id'],
      name: json['name'],
      frequency: json['frequency'],
      frequencyPerWeek: json['frequencyPerWeek'],
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
      frequencyPerWeek: exercise.frequencyPerWeek,
      initialDate: exercise.initialDate,
      intensity: exercise.intensity,
      shortnessOfBreath: exercise.shortnessOfBreath,
      executedDate: exercise.executedDate,
      done: exercise.done,
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

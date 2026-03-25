import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:firebase_database/firebase_database.dart';

class ExerciseModel extends Exercise {
  ExerciseModel({
    required super.executionDay,
    required super.id,
    required super.shortnessOfBreath,
    required super.excessiveFatigue,
    required super.dizziness,
    required super.bodyPain,
    required super.times,
    required super.executionTime,
    required super.observation,
    required super.name,
    required super.frequency,
    required super.intensity,
    required super.durationInMinutes,
    required super.initialDate,
    required super.finalDate,
    required super.done,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      // Usamos o '!' pois o construtor do ExerciseModel já garantiu que esses campos não são nulos
      'executionDay': executionDay!.millisecondsSinceEpoch,
      'initialDate': initialDate!.millisecondsSinceEpoch,
      'finalDate': finalDate!.millisecondsSinceEpoch,
      'name': name,
      'frequency': frequency,
      'intensity': intensity,
      'durationInMinutes': durationInMinutes,
      'excessiveFatigue': excessiveFatigue,
      'shortnessOfBreath': shortnessOfBreath,
      'dizziness': dizziness,
      'bodyPain': bodyPain,
      'executionTime': executionTime,
      'times': times,
      'observation': observation,
      'done': done,
    };
  }

  factory ExerciseModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) throw Exception("JSON de Exercício nulo");

    return ExerciseModel(
      executionDay: (json['executionDay'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['executionDay']),
      initialDate: (json['initialDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['initialDate']),
      finalDate: (json['finalDate'] == null)
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['finalDate']),
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      frequency: json['frequency'] ?? 0,
      intensity: json['intensity'] ?? "",
      durationInMinutes: json['durationInMinutes'] ?? 0,
      shortnessOfBreath: json['shortnessOfBreath'] ?? false,
      excessiveFatigue: json['excessiveFatigue'] ?? false,
      dizziness: json['dizziness'] ?? false,
      bodyPain: json['bodyPain'] ?? false,
      done: json['done'] ?? false,
      executionTime: json['executionTime'] ?? "",
      times: Converter.convertListDynamicToListString(json['times']) ?? [],
      observation: json['observation'] ?? "",
    );
  }

  // Mudado para static para permitir retorno nulo se a entidade for nula
  static ExerciseModel? fromEntity(Exercise? exercise) {
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
    final value = dataSnapshot.value;
    if (value == null) throw Exception("Snapshot vazio");

    final Map<dynamic, dynamic> objectMap = Map<dynamic, dynamic>.from(value as Map);

    objectMap['id'] = dataSnapshot.key;
    objectMap['done'] = done;

    return ExerciseModel.fromJson(objectMap);
  }

  static List<ExerciseModel> fromDataSnapshotList(DataSnapshot dataSnapshot, bool done) {
    final value = dataSnapshot.value;
    if (value == null) return [];

    final List<ExerciseModel> result = [];
    final Map<dynamic, dynamic> objectTodoMap = Map<dynamic, dynamic>.from(value as Map);

    for (var entry in objectTodoMap.entries) {
      final Map<dynamic, dynamic> exerciseMap = Map<dynamic, dynamic>.from(entry.value as Map);
      exerciseMap['id'] = entry.key;
      exerciseMap['done'] = done;
      result.add(ExerciseModel.fromJson(exerciseMap));
    }

    return result;
  }
}
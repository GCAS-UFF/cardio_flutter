import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/add_exercise_page.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/execute_exercise_page.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatefulWidget {
  final Activity activity;

  // 1. Uso do super.key e required nativo
  const ExerciseCard({super.key, required this.activity});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    // Pegamos o exercício para facilitar a leitura
    final exercise = widget.activity.value as Exercise;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (!exercise.done) {
              if (Provider.of<Settings>(context, listen: false).getUserType() ==
                  (Keys.PROFESSIONAL_TYPE)) {
                _showOptionsProfessional(context, exercise);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExecuteExercisePage(
                            exercise: exercise,
                          )),
                );
              }
            } else {
              if (Provider.of<Settings>(context, listen: false).getUserType() !=
                  (Keys.PROFESSIONAL_TYPE)) {
                _showOptionsPatient(context, exercise);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (!exercise.done)
                  ? Colors.lightBlue
                  : Colors.orangeAccent,
              borderRadius: BorderRadius.circular(7),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Text(
                    (!exercise.done) ? "Recomendação" : "Realizado",
                    style: TextStyle(
                        fontSize: Dimensions.getTextSize(context, 16),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.activity.informations.entries.map(
                      (entry) {
                        return _buildParameterItem(context, entry);
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.getConvertedHeightSize(context, 10),
        ),
      ],
    );
  }
}

Widget _buildParameterItem(BuildContext context, MapEntry entry) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text(
        " ${entry.key}:",
        style: TextStyle(
          color: Colors.white,
          fontSize: Dimensions.getTextSize(context, 16),
        ),
      ),
      Text(
        " ${entry.value}",
        style: TextStyle(
          color: Colors.white,
          fontSize: Dimensions.getTextSize(context, 16),
        ),
      )
    ],
  );
}

// 2. Correção da função symptom para suportar Null Safety
String symptom(bool? symptomValue) {
  if (symptomValue == null) return "Não informado";
  return symptomValue ? "Houve" : "Não houve";
}

void _showOptionsPatient(BuildContext context, Exercise exercise) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // 3. FlatButton substituído por TextButton
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExecuteExercisePage(
                      exercise: exercise,
                    ),
                  ),
                );
              },
              child: const Text(
                "Editar",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<ExerciseBloc>(context).add(
                  DeleteExerciseEvent(
                    exercise: exercise,
                  ),
                );
              },
              child: const Text(
                "Excluir",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _showOptionsProfessional(BuildContext context, Exercise exercise) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExercisePage(
                      exercise: exercise,
                    ),
                  ),
                );
              },
              child: const Text(
                "Editar",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<ExerciseBloc>(context).add(
                  DeleteExerciseEvent(
                    exercise: exercise,
                  ),
                );
              },
              child: const Text(
                "Excluir",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
          ],
        ),
      );
    },
  );
}
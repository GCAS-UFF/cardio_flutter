import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/add_exercise_page.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/execute_exercise_page.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCard({@required this.exercise});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (Provider.of<Settings>(context, listen: false).getUserType() ==
                Keys.PROFESSIONAL_TYPE) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddExercisePage(
                    exercise: widget.exercise,
                  ),
                ),
              );
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ExecuteExercisePage(exercise: widget.exercise,) ),);

            }
          },
          child: Container(
            padding: Dimensions.getEdgeInsetsFromLTRB(context, 10, 10, 10, 10),
            decoration: BoxDecoration(
              color: (!widget.exercise.done)
                  ? Colors.lightBlue
                  : Colors.orangeAccent,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (!widget.exercise.done)
                  ? [
                      Text(
                        "Recomendação",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Exercício:  ${(widget.exercise.name != null) ? widget.exercise.name : ""}\n"
                        "Frequência: ${(widget.exercise.frequency != null) ? widget.exercise.frequency : ""} vezes ao dia\n"
                        "Intensidade: ${(widget.exercise.intensity != null) ? widget.exercise.intensity : ""}\n"
                        "Data de Início: ${(widget.exercise.inicialDate != null) ? DateHelper.convertDateToString(widget.exercise.inicialDate) : ""}\n"
                        "Data de Fim: ${(widget.exercise.finalDate != null) ? DateHelper.convertDateToString(widget.exercise.finalDate) : ""}\n"
                        "Duração:  ${(widget.exercise.durationInMinutes != null) ? widget.exercise.durationInMinutes : ""} min",
                        style: TextStyle(color: Colors.white),
                      ),
                    ]
                  : [
                      Text(
                        "Realizado",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${Strings.exercise}:  ${(widget.exercise.name != null) ? widget.exercise.name : ""}\n"
                        //Introduzir o horário
                        "${Strings.intensity}: ${(widget.exercise.intensity != null) ? widget.exercise.intensity : ""}\n"
                        "${Strings.duration}:  ${(widget.exercise.durationInMinutes != null) ? widget.exercise.durationInMinutes : ""} min\n"
                        "Sintomas:\n"
                        "  ${Strings.shortness_of_breath}:  ${(widget.exercise.shortnessOfBreath != null) ? symptom(widget.exercise.shortnessOfBreath) : ""}\n"
                        "  ${Strings.excessive_fatigue}:  ${(widget.exercise.excessiveFatigue != null) ? symptom(widget.exercise.excessiveFatigue) : ""}\n"
                        "  ${Strings.dizziness}:  ${(widget.exercise.dizziness != null) ? symptom(widget.exercise.dizziness) : ""}\n"
                        "  ${Strings.body_pain}:  ${(widget.exercise.bodyPain != null) ? symptom(widget.exercise.bodyPain) : ""}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
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

String symptom(bool symptom) {
  String string;
  if (symptom == null) {
    return null;
  } else {
    (symptom == true) ? string = "Houve" : string = "Não houve";
    return string;
  }
}

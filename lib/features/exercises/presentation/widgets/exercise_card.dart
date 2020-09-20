import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/add_exercise_page.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/execute_exercise_page.dart';
import 'package:cardio_flutter/features/exercises/presentation/widgets/done_recomendation_detail_tile.dart';
import 'package:cardio_flutter/features/exercises/presentation/widgets/recomendation_detail_tile.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCard({Key key, @required this.exercise}) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  TextStyle _textStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textStyle = TextStyle(
      fontSize: Dimensions.getTextSize(context, 22),
      fontWeight: FontWeight.normal,
      color: CardioColors.black,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        widget.exercise.done
            ? Container(
                padding: Dimensions.getEdgeInsets(context,
                    left: 10, top: 3, right: 10, bottom: 3),
                width: double.infinity,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: CardioColors.green_01,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ExpansionTile(
                  title: Text(
                    "Realizado",
                    style: _textStyle,
                  ),
                  backgroundColor: CardioColors.transparent,
                  children: widget.exercise.informations.entries.map(
                    (entry) {
                      return entry?.value != null
                          ? _buildParameterItem(context, entry)
                          : Container();
                    },
                  ).toList(),
                ),
              )
            : Container(
                padding: Dimensions.getEdgeInsets(context,
                    left: 10, top: 3, right: 10, bottom: 3),
                width: double.infinity,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: CardioColors.grey_02,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ExpansionTile(
                  title: Text(
                    "Recomendação",
                    style: _textStyle,
                  ),
                  backgroundColor: CardioColors.transparent,
                  children:
                      _buildDetails(context, widget.exercise.informations),
                ),
              ),
        SizedBox(
          height: Dimensions.getConvertedHeightSize(context, 10),
        ),
      ],
    );
  }
  Widget _buildParameterItem(BuildContext context, MapEntry entry) {
    return widget.exercise.done
        ? DoneRecomendationDetailTile(
            title: entry.key,
            content: entry.value,
          )
        : RecomendationDetailTile(
            title: entry.key,
            content: entry.value,
          );
  }
  List<Widget> _buildDetails(
      BuildContext context, Map<String, String> informations) {
    List<Widget> list = informations.entries.map(
      (entry) {
        return entry?.value != null
            ? _buildParameterItem(context, entry)
            : Container();
      },
    ).toList();
    list.add(
      Container(
        padding: Dimensions.getEdgeInsets(context, top: 10, bottom: 10),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: CardioColors.transparent,
          border: Border(
            top: BorderSide(
              color: CardioColors.grey_06,
              width: Dimensions.getConvertedHeightSize(context, 1),
            ),
          ),
        ),
        child: GestureDetector(
          child: Container(
            width: double.infinity,
            padding: Dimensions.getEdgeInsets(context, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Dimensions.getConvertedHeightSize(context, 10),
                ),
              ),
              color: CardioColors.blue,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.add_circle_outline,
                  color: CardioColors.white,
                  size: Dimensions.getConvertedHeightSize(context, 18),
                ),
                SizedBox(
                  width: Dimensions.getConvertedWidthSize(context, 5),
                ),
                Text(
                  "Realizar",
                  style: TextStyle(
                    fontSize: Dimensions.getTextSize(context, 20),
                    fontWeight: FontWeight.normal,
                    color: CardioColors.white,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ExecuteExercisePage(exercise: widget.exercise)));
          } ??
              () => debugPrint("[JP] Realizar atividade"),
        ),
      ),
    );
    return list;
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

void _showOptionsPatient(BuildContext context, Exercise exercise) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
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
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<ExerciseBloc>(context).add(
                          DeleteExerciseEvent(
                            exercise: exercise,
                          ),
                        );
                      },
                      child: Text(
                        "Excluir ",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    },
  );
}

void _showOptionsProfessional(BuildContext context, Exercise exercise) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
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
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<ExerciseBloc>(context).add(
                          DeleteExerciseEvent(
                            exercise: exercise,
                          ),
                        );
                      },
                      child: Text(
                        "Excluir ",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    },
  );
}

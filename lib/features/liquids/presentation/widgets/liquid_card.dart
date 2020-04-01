import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/features/liquids/presentation/pages/add_liquid_page.dart';
import 'package:cardio_flutter/features/liquids/presentation/pages/execute_liquid_page.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class LiquidCard extends StatefulWidget {
  final Activity activity;

  const LiquidCard({Key key, @required this.activity}) : super(key: key);

  @override
  _LiquidCardState createState() => _LiquidCardState();
}

class _LiquidCardState extends State<LiquidCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (!widget.activity.value.done) {
              if (Provider.of<Settings>(context, listen: false).getUserType() ==
                  (Keys.PROFESSIONAL_TYPE)) {
                return _showOptionsProfessional(context, widget.activity.value);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExecuteLiquidPage(
                            liquid: widget.activity.value,
                          )),
                );
              }
            } else {
              if (Provider.of<Settings>(context, listen: false).getUserType() ==
                  (Keys.PROFESSIONAL_TYPE)) {
              } else {
                return _showOptionsPatient(context, widget.activity.value);
              }
            }
          },
          child: Container(
            padding: Dimensions.getEdgeInsetsFromLTRB(context, 10, 10, 10, 10),
            decoration: BoxDecoration(
              color: (!widget.activity.value.done)
                  ? Colors.lightBlue
                  : Colors.orangeAccent,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: ((!widget.activity.value.done))
                  ? [
                      Text(
                        "Recomendação",
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
                    ]
                  : [
                      Text(
                        "Realizado",
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
                      )
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

String symptom(bool symptom) {
  String string;
  if (symptom == null) {
    return null;
  } else {
    (symptom == true) ? string = "Houve" : string = "Não houve";
    return string;
  }
}

void _showOptionsPatient(BuildContext context, Liquid liquid) {
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
                              builder: (context) => ExecuteLiquidPage(
                                liquid: liquid,
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
                        // BlocProvider.of<ExerciseBloc>(context).add(
                        //   DeleteExerciseEvent(
                        //     exercise: exercise,
                        //   ),
                        // );
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

void _showOptionsProfessional(BuildContext context, Liquid liquid) {
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
                            builder: (context) => AddLiquidPage(
                              liquid: liquid,
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
                      // BlocProvider.of<ExerciseBloc>(context).add(
                      //   DeleteExerciseEvent(
                      //     exercise: exercise,
                      //   ),
                      // );
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
        },
      );
    },
  );
}

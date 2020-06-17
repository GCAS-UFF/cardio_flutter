import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class EntityCard extends StatefulWidget {
  final Activity activity;
  final Function openExecuted;
  final Function openRecomendation;
  final Function delete;

  const EntityCard(
      {Key key,
      @required this.activity,
      @required this.openExecuted,
      @required this.openRecomendation,
      @required this.delete})
      : super(key: key);

  @override
  _EntityCardState createState() => _EntityCardState();
}

class _EntityCardState extends State<EntityCard> {
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
                return _showOptionsProfessional(context);
              } else {
                if (widget.openExecuted != null) {
                  widget.openExecuted();
                }
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
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ((!widget.activity.value.done))
                    ? [
                        Text(
                          " Recomendação",
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
                          " Realizado",
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
        ),
        SizedBox(
          height: Dimensions.getConvertedHeightSize(context, 10),
        ),
      ],
    );
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

  void _showOptionsPatient(BuildContext context, BaseEntity entity) {
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
                            if (widget.openExecuted != null) {
                              widget.openExecuted();
                            }
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
                          if (widget.delete != null) {
                            widget.delete();
                          }
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

  void _showOptionsProfessional(BuildContext context) {
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
                          if (widget.openRecomendation != null) {
                            widget.openRecomendation();
                          }
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
                        if (widget.delete != null) {
                          widget.delete();
                        }
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
}

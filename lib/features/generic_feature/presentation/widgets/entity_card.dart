import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/generic_feature/domain/entities/base_entity.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/widgets/done_recomendation_detail_tile.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/widgets/recomendation_detail_tile.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
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
  TextStyle _textStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textStyle = TextStyle(
      fontSize: Dimensions.getTextSize(context, 20),
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
        // Recomendaion
        Container(
          padding: Dimensions.getEdgeInsets(context,
              left: 10, top: 3, right: 10, bottom: 3),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: CardioColors.grey_02,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: ExpansionTile(
            title: Text.rich(
              TextSpan(
                style: _textStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: "Medir ",
                  ),
                  TextSpan(
                    text: "2 vezes",
                    style: _textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " ao dia",
                  ),
                ],
              ),
            ),
            backgroundColor: CardioColors.transparent,
            children: <Widget>[
              RecomendationDetailTile(
                title: "Horário(s) recomendado(s): ",
                content: "06:00, 14:00, 22:00",
              ),
              RecomendationDetailTile(
                title: "Data de início: ",
                content: "07/09/2020",
              ),
              RecomendationDetailTile(
                title: "Data de fim: ",
                content: "09/09/2020",
              ),
            ],
          ),
        ),
        // Border
        Container(
          color: CardioColors.black,
          height: Dimensions.getConvertedHeightSize(context, 1),
          width: double.infinity,
        ),
        // Done recomendations
        Container(
          padding: Dimensions.getEdgeInsets(context,
              left: 10, top: 3, right: 10, bottom: 3),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: CardioColors.grey_02,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: ExpansionTile(
            title: Text.rich(
              TextSpan(
                style: _textStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: "Realizados: ",
                  ),
                  TextSpan(
                    text: "0",
                    style: _textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: CardioColors.transparent,
            children: <Widget>[
              Container(
                margin: Dimensions.getEdgeInsets(context, left: 20, bottom: 10),
                padding: Dimensions.getEdgeInsets(context, left: 10, right: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CardioColors.green_01,
                  borderRadius: BorderRadius.circular(
                    Dimensions.getConvertedHeightSize(context, 10),
                  ),
                ),
                child: ExpansionTile(
                  backgroundColor: CardioColors.transparent,
                  title: Text(
                    "10:00",
                    style: TextStyle(
                      fontSize: Dimensions.getTextSize(context, 20),
                      color: CardioColors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  children: <Widget>[
                    DoneRecomendationDetailTile(),
                    DoneRecomendationDetailTile(),
                  ],
                ),
              ),
              Container(
                margin: Dimensions.getEdgeInsets(context, left: 20, bottom: 10),
                padding: Dimensions.getEdgeInsets(context, left: 10, right: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CardioColors.green_01,
                  borderRadius: BorderRadius.circular(
                    Dimensions.getConvertedHeightSize(context, 10),
                  ),
                ),
                child: ExpansionTile(
                  backgroundColor: CardioColors.transparent,
                  title: Text(
                    "10:00",
                    style: TextStyle(
                      fontSize: Dimensions.getTextSize(context, 20),
                      color: CardioColors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  children: <Widget>[
                    DoneRecomendationDetailTile(),
                    DoneRecomendationDetailTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

/*
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
*/
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

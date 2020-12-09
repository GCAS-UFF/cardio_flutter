import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/widgets/done_recomendation_detail_tile.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/widgets/recomendation_detail_tile.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class EntityCard extends StatefulWidget {
  final Activity activity;
  final Function openExecuted;
  final Function openRecomendation;
  final Function delete;

  const EntityCard({
    Key key,
    @required this.activity,
    @required this.openExecuted,
    @required this.openRecomendation,
    @required this.delete,
  }) : super(key: key);

  @override
  _EntityCardState createState() => _EntityCardState();
}

class _EntityCardState extends State<EntityCard> {
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
        widget.activity.value.done
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
                  onExpansionChanged: (stateExpasionTitle) {
                    if (stateExpasionTitle) {
                      Mixpanel.trackEvent(
                        MixpanelEvents.OPEN_ACTION_DETAIL,
                        data: widget.activity.informations,
                      );
                    }
                  },
                  title: Text(
                    "Realizado",
                    style: _textStyle,
                  ),
                  backgroundColor: CardioColors.transparent,
                  children: widget.activity.informations.entries.map(
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
                  onExpansionChanged: (stateExpasionTitle) {
                    if (stateExpasionTitle) {
                      Mixpanel.trackEvent(
                          MixpanelEvents.OPEN_RECOMENDATION_DETAIL,
                          data: widget.activity.informations);
                    }
                  },
                  title: Text(
                    "Recomendação",
                    style: _textStyle,
                  ),
                  backgroundColor: CardioColors.transparent,
                  children:
                      _buildDetails(context, widget.activity.informations),
                ),
              ),
        SizedBox(
          height: Dimensions.getConvertedHeightSize(context, 10),
        ),
      ],
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
          onTap: widget.openExecuted ??
              () => debugPrint("[JP] Realizar atividade"),
        ),
      ),
    );
    return list;
  }

  Widget _buildParameterItem(BuildContext context, MapEntry entry) {
    return widget.activity.value.done
        ? DoneRecomendationDetailTile(
            title: entry.key,
            content: entry.value,
          )
        : RecomendationDetailTile(
            title: entry.key,
            content: entry.value,
          );
  }
}

import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class ClickableItem extends StatefulWidget {
  final String title;
  final InlineSpan text;
  final MixpanelEvents event;
  bool isOpen;

  ClickableItem({this.title, this.text, this.event, this.isOpen = false});
  @override
  _ClickableItemState createState() => _ClickableItemState();
}

class _ClickableItemState extends State<ClickableItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Dimensions.getEdgeInsets(context, left: 15, bottom: 20),
      width: double.infinity,
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              padding: Dimensions.getEdgeInsets(context, bottom: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: Dimensions.getConvertedHeightSize(context, 1),
                    color: CardioColors.black,
                  ),
                ),
              ),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: Dimensions.getTextSize(context, 22),
                  fontWeight: FontWeight.w500,
                  color: CardioColors.black,
                ),
              ),
            ),
            widget.isOpen
                ? Container(
                    width: double.infinity,
                    padding: Dimensions.getEdgeInsets(context,
                        left: 10, top: 10, right: 15, bottom: 15),
                    color: CardioColors.grey_01,
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [widget.text],
                        style: TextStyle(
                          color: CardioColors.black,
                          fontSize: Dimensions.getTextSize(context, 20),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        onTap: () {
          setState(() => widget.isOpen = !widget.isOpen);
          if (widget.isOpen)
            Mixpanel.trackEvent(
              widget.event,
              data: {"itemOpen": widget.title},
            );
        },
      ),
    );
  }
}

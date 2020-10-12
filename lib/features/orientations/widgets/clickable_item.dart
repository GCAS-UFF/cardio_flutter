import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class ClickableItem extends StatefulWidget {
  final String title;
  final InlineSpan text;
  bool isClicked;

  ClickableItem({this.title, this.text, this.isClicked = false});
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
            widget.isClicked
                ? Container(
                    width: double.infinity,
                    padding: Dimensions.getEdgeInsets(context, left: 10, top: 10, right: 15, bottom: 15),
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
          setState(() => widget.isClicked = !widget.isClicked);
        },
        // Container(
        //   decoration: BoxDecoration(
        //       border: Border.all(
        //         color: Colors.black54,
        //         width: Dimensions.getConvertedHeightSize(context, 2),
        //       ),
        //       borderRadius: BorderRadius.circular(8)),
        //   alignment: Alignment.center,
        //   child: (widget.isClicked)
        //       ? Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(
        //             widget.title,
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //                 color: Colors.indigo[900],
        //                 fontSize: Dimensions.getTextSize(context, 16),
        //                 fontWeight: FontWeight.bold),
        //           ),
        //         )
        //       : Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: <Widget>[
        //             Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Text(
        //                 widget.title,
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                     color: Colors.indigo[900],
        //                     fontSize: Dimensions.getTextSize(context, 16),
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 10),
        //               child: Divider(
        //                 thickness: 2,
        //                 color: Colors.blueGrey[600],
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: RichText(
        //                 textAlign: TextAlign.justify,
        //                 text: TextSpan(
        //                   children: [widget.text],
        //                   style: TextStyle(
        //                     color: Colors.black,
        //                     fontSize: Dimensions.getTextSize(context, 16),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        // ),
      ),
    );
  }
}

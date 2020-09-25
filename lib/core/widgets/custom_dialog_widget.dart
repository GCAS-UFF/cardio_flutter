import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import '../../resources/dimensions.dart';

class CustomDialogWidget extends StatelessWidget {
  final String text;
  final Function onPressed;

  CustomDialogWidget({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CardioColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: CardioColors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: CardioColors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              // height: Dimensions.getConvertedHeightSize(context, 50),
              padding: Dimensions.getEdgeInsets(context, top: 5, bottom: 5),
              margin: Dimensions.getEdgeInsets(context, bottom: 10),
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CardioColors.white,
                  shape: BoxShape.circle,
                ),
                padding: Dimensions.getEdgeInsetsAll(context, 5),
                child: Icon(
                  Icons.assistant_photo,
                  color: CardioColors.red,
                  size: Dimensions.getConvertedHeightSize(context, 30),
                ),
              ),
            ),
            Container(
              padding: Dimensions.getEdgeInsets(context,
                  right: 15, left: 15, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Strings.warning,
                    style: TextStyle(
                      fontSize: Dimensions.getTextSize(context, 24),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.getConvertedHeightSize(context, 15),
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.getTextSize(context, 20),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.getConvertedHeightSize(context, 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: CardioColors.grey_02,
                        shape: new RoundedRectangleBorder(
                          side: BorderSide(
                            color: CardioColors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          Strings.cancel,
                          style: TextStyle(
                            color: CardioColors.black,
                            fontSize: Dimensions.getTextSize(context, 20),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: onPressed,
                        color: CardioColors.blue,
                        shape: new RoundedRectangleBorder(
                          // side: BorderSide(
                          //   color: CardioColors.black,
                          //   width: 1,
                          //   style: BorderStyle.solid,
                          // ),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          Strings.okbutton,
                          style: TextStyle(
                            color: CardioColors.white,
                            fontSize: Dimensions.getTextSize(context, 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

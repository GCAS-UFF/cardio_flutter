import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/strings.dart';

import '../../resources/dimensions.dart';

class DialogWidget extends StatelessWidget {
  final String text;
  final Function onPressed;

  DialogWidget({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: Colors.red,
            size: Dimensions.getConvertedHeightSize(context, 25),
          ),
          Text(
            Strings.warning,
            style: TextStyle(
              fontSize: Dimensions.getTextSize(context, 22),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      content: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.black,
          fontSize: Dimensions.getTextSize(context, 15),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            Strings.cancel,
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getTextSize(context, 15)),
          ),
        ),
        FlatButton(
          onPressed: onPressed,
          child: Text(
            Strings.okbutton,
            style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getTextSize(context, 15)),
          ),
        ),
      ],
    );
  }
}

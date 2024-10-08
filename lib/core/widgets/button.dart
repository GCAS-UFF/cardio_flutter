import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Button extends StatelessWidget {
  final String title;
  final Function onTap;

  Button({@required this.title, @required this.onTap})
      : assert(title != null, onTap != null);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.indigo, offset: Offset(3, 3), blurRadius: 5)
        ], borderRadius: BorderRadius.circular(5), color: Colors.teal),
       height: Dimensions.getConvertedHeightSize(context, 50),
     width: Dimensions.getConvertedWidthSize(context, 180),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimensions.getTextSize(context, 20),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
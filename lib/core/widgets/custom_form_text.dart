import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class CustomFormText extends StatelessWidget {
  final String title;
  final String hint;

  CustomFormText({@required this.title, @required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: Dimensions.getConvertedHeightSize(context, 30),
          width: Dimensions.getConvertedWidthSize(context, 300),
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          child: Text(
            "  $title",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.indigo, offset: Offset(3, 3), blurRadius: 5)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          height: Dimensions.getConvertedHeightSize(context, 50),
          width: Dimensions.getConvertedWidthSize(context, 300),
          alignment: Alignment.centerLeft,
          child: Text(
            "  $hint",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

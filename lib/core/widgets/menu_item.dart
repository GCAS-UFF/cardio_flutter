import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/images.dart';

class ItemMenu extends StatelessWidget {
  final String text;
  final String image;
  final Function destination;

  const ItemMenu(
      {Key key, this.text = "", this.image = Images.app_logo, this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimensions.getEdgeInsetsAll(context, 8),
      child: InkWell(
        onTap: destination,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: Offset(3, 3),
                color: Colors.indigo,
                blurRadius: 3,
              ),
            ],
            color: Color(0xffc9fffd),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.topLeft,
          width: Dimensions.getConvertedWidthSize(context, 300),
          height: Dimensions.getConvertedHeightSize(context, 45),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: Dimensions.getConvertedWidthSize(context, 5),
              ),
              Padding(
                padding: Dimensions.getEdgeInsetsAll(context, 2),
                child: Image.asset(image),
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: Dimensions.getTextSize(context, 15),
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

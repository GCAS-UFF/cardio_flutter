import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cardio_flutter/resources/dimensions.dart';

class CustomSelector extends StatelessWidget {
  final String title;
  final List<String> options;
  final Function onChanged;
  final String subtitle;

  const CustomSelector(
      {this.title, this.options, this.onChanged, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            "$title",
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.getTextSize(context, 20),
              fontWeight: FontWeight.w500,
            ),
            strutStyle: StrutStyle.disabled,
          ),
        ),
        InkWell(
          child: Container(
            // margin: Dimensions.getEdgeInsetsSymetric(context, horizontal: 15),
            padding: Dimensions.getEdgeInsets(
              context,
              left: 5,
              right: 15,
              top: 5,
              bottom: 5,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: CardioColors.black,
                width: Dimensions.getConvertedHeightSize(context, 1),
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  (subtitle == null) ? "Selecione" : subtitle,
                  style: TextStyle(
                    fontSize: Dimensions.getTextSize(context, 20),
                    color: CardioColors.grey_04,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                )
              ],
            ),
            height: Dimensions.getConvertedHeightSize(context, 50),
            alignment: Alignment.centerLeft,
          ),
          onTap: () {
            // subtitle = options[0];
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: Container(
                    width: MediaQuery.of(context).size.width - 1,
                    height: Dimensions.getConvertedHeightSize(context, 150),
                    child: CupertinoPicker.builder(
                      useMagnifier: true,
                      childCount: options.length,
                      backgroundColor: Colors.white54,
                      itemExtent:
                          Dimensions.getConvertedHeightSize(context, 50),
                      onSelectedItemChanged: onChanged,
                      diameterRatio: 2,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            options[index],
                            style: TextStyle(
                              fontSize: Dimensions.getTextSize(context, 20),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  actions: <Widget>[
                    Container(
                      margin: Dimensions.getEdgeInsets(context,
                          bottom: 10, right: 10),
                      child: FlatButton(
                        onPressed: () {
                          return Navigator.pop(context);
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                            fontSize: Dimensions.getTextSize(context, 15),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

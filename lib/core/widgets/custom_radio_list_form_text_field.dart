import 'package:cardio_flutter/core/widgets/custom_radio_item.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

enum YesNoRadioOptions {
  YES,
  NO,
}

class CustomRadioListFormField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final Function onChanged;
  final bool enable;
  final YesNoRadioOptions groupValue;

  CustomRadioListFormField({
    this.textEditingController,
    @required this.title,
    this.onChanged,
    this.enable = true,
    this.groupValue,
  });

  @override
  _CustomRadioListFormFieldState createState() =>
      _CustomRadioListFormFieldState();
}

class _CustomRadioListFormFieldState extends State<CustomRadioListFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(
            color: CardioColors.black,
            fontSize: Dimensions.getTextSize(context, 20),
            fontWeight: FontWeight.w500,
          ),
          strutStyle: StrutStyle.disabled,
        ),
        Container(
          width: double.infinity,
          padding:
              Dimensions.getEdgeInsets(context, left: 15, top: 15, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Dimensions.getConvertedHeightSize(context, 5),
            ),
            border: Border.all(
              color: CardioColors.black,
              width: Dimensions.getConvertedHeightSize(context, 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomRadioItem(
                label: "Sim",
                value: YesNoRadioOptions.YES,
                groupValue: widget.groupValue,
                onChanged: widget.onChanged,
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 15),
              ),
              CustomRadioItem(
                label: "Não",
                value: YesNoRadioOptions.NO,
                groupValue: widget.groupValue,
                onChanged: widget.onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

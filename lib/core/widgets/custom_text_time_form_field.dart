import 'package:cardio_flutter/core/input_validators/base_input_validator.dart';
import 'package:cardio_flutter/core/input_validators/empty_input_validator.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class CustomTextTimeFormField extends StatefulWidget {
  final TextEditingController textEditingController;
  final BaseInputValidator validator;
  final bool isRequired;
  final Function onChanged;

  CustomTextTimeFormField({
    this.textEditingController,
    this.validator,
    this.isRequired = true,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomTextTimeFormFieldState();
  }
}

class _CustomTextTimeFormFieldState extends State<CustomTextTimeFormField> {
  bool _shouldValidate = false;

  String _validate(String value) {
    if (widget.isRequired != null && widget.isRequired) {
      String message = EmptyInputValidator().validate(value);
      if (message != null) return message;
    }

    if (widget.validator != null) {
      return widget.validator.validate(value);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimensions.getEdgeInsetsSymetric(context, horizontal: 5),
      child: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
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
            width: Dimensions.getConvertedWidthSize(context, 70),
            alignment: Alignment.centerLeft,
          ),
          Container(
            width: Dimensions.getConvertedWidthSize(context, 70),
            child: TextFormField(textAlign: TextAlign.center,
              controller: widget.textEditingController,
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.getTextSize(context, 20),
              ),
              keyboardType: TextInputType.number,
              autovalidate: _shouldValidate,
              decoration: InputDecoration(
                hintText: Strings.time_hint,
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: Dimensions.getTextSize(context, 15.0),
                ),
                hintStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: Dimensions.getTextSize(context, 20),
                ),
                counterText: "",
                border: InputBorder.none,
              ),
              validator: _validate,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

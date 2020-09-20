import 'package:cardio_flutter/core/input_validators/base_input_validator.dart';
import 'package:cardio_flutter/core/input_validators/empty_input_validator.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final String hintText;
  final BaseInputValidator validator;
  final bool isRequired;
  final Function onChanged;
  final int maxLength;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final int maxLines;
  final bool enable;
  final String initialValue;

  CustomTextFormField({
    this.textEditingController,
    @required this.hintText,
    @required this.title,
    this.maxLength,
    this.keyboardType,
    this.validator,
    this.isRequired = false,
    this.obscureText = false,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.enable = true,
    this.initialValue,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomTextFormFieldState();
  }
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
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
    return Container(
      // color: Colors.amber,
      child: Column(
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
          TextFormField(
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            enabled: widget.enable,
            validator: _validate,
            maxLength: widget.maxLength,
            obscureText: widget.obscureText,
            textCapitalization: widget.textCapitalization,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
            initialValue: widget.initialValue,
            style: TextStyle(
              color: CardioColors.black,
              fontSize: Dimensions.getTextSize(context, 20),
            ),
            controller: widget.textEditingController,
            decoration: InputDecoration(
              contentPadding: Dimensions.getEdgeInsets(context,
                  top: 10, bottom: 10, left: 6),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: Dimensions.getTextSize(context, 20),
                color: CardioColors.grey_02,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: CardioColors.black,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: CardioColors.black,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: CardioColors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: Dimensions.getEdgeInsetsSymetric(context, horizontal: 15),
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           height: Dimensions.getConvertedHeightSize(context, 30),
  //           width: Dimensions.getConvertedWidthSize(context, 300),
  //           color: Colors.transparent,
  //           alignment: Alignment.centerLeft,
  //           child: Text(
  //             "  ${widget.title}",
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontSize: Dimensions.getTextSize(context, 20),
  //             ),
  //           ),
  //         ),
  //         Stack(
  //           alignment: Alignment.topLeft,
  //           children: <Widget>[
  //             Container(
  //               decoration: BoxDecoration(
  //                 boxShadow: <BoxShadow>[
  //                   BoxShadow(
  //                       color: Colors.indigo,
  //                       offset: Offset(3, 3),
  //                       blurRadius: 5)
  //                 ],
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(
  //                   10,
  //                 ),
  //               ),
  //               height: Dimensions.getConvertedHeightSize(context, 50),
  //               alignment: Alignment.centerLeft,
  //             ),
  //             TextFormField(
  //               initialValue: widget.initialValue,
  //               enabled: widget.enable,
  //               controller: widget.textEditingController,
  //               textAlign: widget.textAlign,
  //               style: TextStyle(
  //                 color: (widget.enable)
  //                     ? Colors.black
  //                     : Colors.black.withOpacity(0.5),
  //                 fontSize: Dimensions.getTextSize(context, 20),
  //               ),
  //               maxLength: widget.maxLength,
  //               keyboardType: widget.keyboardType,
  //               obscureText: widget.obscureText,
  //               autovalidate: _shouldValidate,
  //               textCapitalization: widget.textCapitalization,
  //               decoration: InputDecoration(
  //                 prefixText: "  ",
  //                 hintText: widget.hintText,
  //                 errorStyle: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: Dimensions.getTextSize(context, 15.0),
  //                 ),
  //                 hintStyle: TextStyle(
  //                   color: Colors.black45,
  //                   fontSize: Dimensions.getTextSize(context, 20),
  //                 ),
  //                 counterText: "",
  //                 border: InputBorder.none,
  //               ),
  //               validator: _validate,
  //               onChanged: widget.onChanged,
  //               maxLines: widget.maxLines,
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
}

import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropdownFormField extends StatefulWidget {
  final Function onChanged;
  final List<String> dropDownList;
  final String hintText;
  final String title;

  const CustomDropdownFormField({
    Key key,
    this.onChanged,
    this.dropDownList,
    this.hintText = "Selecione",
    this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomDropdownFormFieldState();
  }
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  String _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.title != null
            ? Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: CardioColors.black,
                      fontSize: Dimensions.getTextSize(context, 20),
                      fontWeight: FontWeight.w500,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.title,
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        // SizedBox(
        //   height: Dimensions.getConvertedHeightSize(context, 10),
        // ),
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                value: _selectedOption,
                isExpanded: true,
                icon: Container(),
                style: TextStyle(
                  color: CardioColors.black,
                  fontSize: Dimensions.getTextSize(context, 20),
                  fontWeight: FontWeight.normal,
                ),
                hint: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.hintText ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CardioColors.grey_02,
                          fontSize: Dimensions.getTextSize(context, 20),
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                ),
                items: widget?.dropDownList
                    ?.map<DropdownMenuItem<String>>(
                      (String element) => DropdownMenuItem<String>(
                        value: element,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                element,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    ?.toList(),
                onChanged: (String newValue) {
                  setState(() {
                    _selectedOption = newValue;
                    widget.onChanged(newValue);
                  });
                },
                decoration:
                    InputDecorationGabrielForms().inputDecoration(context),
              ),
            ),
            Container(
              height: Dimensions.getConvertedHeightSize(context, 43),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding:
                        Dimensions.getEdgeInsets(context, right: 14, left: 2),
                    child: SvgPicture.asset(
                      Images.arrow_down,
                      width: Dimensions.getConvertedWidthSize(context, 14),
                      color: CardioColors.blue,
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

class InputDecorationGabrielForms {
  inputDecoration(BuildContext context,
      {String hintText, bool hasLoading = false, bool isLoading = false}) {
    return InputDecoration(
      prefixText: "  ",
      suffixText: !hasLoading ? "  " : null,
      suffix: !hasLoading
          ? null
          : !isLoading
              ? null
              : Container(
                  padding: Dimensions.getEdgeInsets(context, right: 15),
                  child: LoadingWidget(
                    SizedBox.shrink(),
                    size: 12,
                    strokeWidth: 3,
                  ),
                ),
      errorStyle: TextStyle(
        color: Colors.red,
        fontSize: Dimensions.getTextSize(context, 16),
      ),
      hintStyle: TextStyle(
        color: CardioColors.black,
        fontSize: Dimensions.getTextSize(context, 20),
      ),
      counterText: "",
      filled: true,
      fillColor: CardioColors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          style: BorderStyle.solid,
          color: CardioColors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),

      /// The border to display when the [InputDecorator] has the focus and is
      /// showing an error.
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          style: BorderStyle.solid,
          color: CardioColors.red,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),

      /// The border to display when the [InputDecorator] does not have the focus and
      /// is showing an error.
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          style: BorderStyle.solid,
          color: CardioColors.red,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),

      /// The border to display when the [InputDecorator] has the focus and is not
      /// showing an error.
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          style: BorderStyle.solid,
          color: CardioColors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),

      /// The border to display when the [InputDecorator] is enabled and is not
      /// showing an error.
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          style: BorderStyle.solid,
          color: CardioColors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),

      /// The border to display when the [InputDecorator] is disabled and is not
      /// showing an error.
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          style: BorderStyle.solid,
          color: CardioColors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),

      hintText: hintText,
      contentPadding: Dimensions.getEdgeInsetsFromLTRB(context, 0, 8, 0, 8),
    );
  }
}

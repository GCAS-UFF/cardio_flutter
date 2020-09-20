import 'package:cardio_flutter/core/widgets/custom_radio_list_form_text_field.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class CustomRadioItem extends StatefulWidget {
  final String label;
  final EdgeInsets padding;
  final YesNoRadioOptions groupValue;
  final YesNoRadioOptions value;
  final Function onChanged;

  const CustomRadioItem(
      {Key key,
      this.label,
      this.padding,
      this.groupValue,
      this.value,
      this.onChanged})
      : super(key: key);

  @override
  _CustomRadioItemState createState() => _CustomRadioItemState();
}

class _CustomRadioItemState extends State<CustomRadioItem> {
  Widget _uncheckedWidget;
  Widget _checkedWidget;

  @override
  void didChangeDependencies() {
    _uncheckedWidget = Container(
      key: GlobalKey(),
      height: Dimensions.getConvertedHeightSize(context, 14),
      width: Dimensions.getConvertedWidthSize(context, 14),
      decoration: BoxDecoration(
        color: CardioColors.grey_01,
        shape: BoxShape.circle,
      ),
    );
    _checkedWidget = Container(
      key: GlobalKey(),
      height: Dimensions.getConvertedHeightSize(context, 14),
      width: Dimensions.getConvertedWidthSize(context, 14),
      decoration: BoxDecoration(
        color: CardioColors.blue,
        shape: BoxShape.circle,
        // border: Border.all(
        //   width: 1,
        //   color: ColorsGabriel.black_02,
        // ),
      ),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.value != widget.groupValue) {
          widget.onChanged(widget.value);
        }
      },
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        // width: Dimensions.getConvertedWidthSize(context, 256),
        // height: Dimensions.getConvertedHeightSize(context, 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildAnimatedCheckbox(context),
            SizedBox(
              width: Dimensions.getConvertedWidthSize(context, 10),
            ),
            // Label
            Text(
              widget.label,
              strutStyle: StrutStyle(forceStrutHeight: true),
              style: TextStyle(
                color: CardioColors.black,
                fontSize: Dimensions.getTextSize(context, 20),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCheckbox(BuildContext context) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        color: CardioColors.grey_01,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.value == widget.groupValue
              ? CardioColors.blue
              : CardioColors.grey_04,
          width: 1,
        ),
      ),
      child: AnimatedSwitcher(
        child: widget.value == widget.groupValue
            ? _checkedWidget
            : _uncheckedWidget,
        duration: Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(
          child: child,
          scale: animation,
        ),
      ),
    );
  }
}

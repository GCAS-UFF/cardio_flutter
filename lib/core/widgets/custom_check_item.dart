import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class CustomCheckItem extends StatefulWidget {
  final String label;
  final bool value;
  final Function onChanged;

  CustomCheckItem({Key key, this.label, this.value, this.onChanged})
      : super(key: key);

  @override
  _CustomCheckItemState createState() => _CustomCheckItemState();
}

class _CustomCheckItemState extends State<CustomCheckItem> {
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
        shape: BoxShape.rectangle,
      ),
    );
    _checkedWidget = Container(
      key: GlobalKey(),
      height: Dimensions.getConvertedHeightSize(context, 14),
      width: Dimensions.getConvertedWidthSize(context, 14),
      decoration: BoxDecoration(
        color: CardioColors.blue,
        shape: BoxShape.rectangle,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        widget.onChanged(!widget.value);
      }),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
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
        shape: BoxShape.rectangle,
        border: Border.all(
          color: widget.value ? CardioColors.blue : CardioColors.grey_04,
          width: 1,
        ),
      ),
      child: AnimatedSwitcher(
        child: widget.value ? _checkedWidget : _uncheckedWidget,
        duration: Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(
          child: child,
          scale: animation,
        ),
      ),
    );
  }
}

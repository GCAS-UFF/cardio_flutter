import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class IconSideMenuHeader extends StatelessWidget {
  final String userName;
  final String userCpf;
  const IconSideMenuHeader({
    Key key,
    @required this.userName = "Fulano",
    @required this.userCpf = "111.111.111-11",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Dimensions.getEdgeInsets(
        context,
        top: 20,
        left: 60,
        right: 60,
      ),
      // height: Dimensions.getConvertedHeightSize(context, 100),
      decoration: BoxDecoration(
          // border: Border(
          //   bottom: BorderSide(
          //     color: CardioColors.black,
          //     width: Dimensions.getConvertedHeightSize(context, 1),
          //   ),
          // ),
          // color: CardioColors.grey_07,
          ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            Images.app_logo,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: Dimensions.getConvertedHeightSize(context, 10),
          ),
          Text(
            "CARD.IO",
            style: TextStyle(
              color: CardioColors.blue,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.getTextSize(context, 25),
            ),
            strutStyle: StrutStyle.disabled,
          ),
          SizedBox(
            height: Dimensions.getConvertedHeightSize(context, 10),
          ),
        ],
      ),
    );
  }
}

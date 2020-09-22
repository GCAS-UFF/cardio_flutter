import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class SideMenuHeader extends StatelessWidget {
  final String userName;
  final String userCpf;
  const SideMenuHeader({
    Key key,
    @required this.userName = "Fulano",
    @required this.userCpf = "111.111.111-11",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> names = userName.split(" ");
    String _fullname = "${names[0]} ${names.last}";
    return Container(
      padding: Dimensions.getEdgeInsets(
        context,
        left: 14,
        top: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CardioColors.black,
            width: Dimensions.getConvertedHeightSize(context, 1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /// Profile avatar
          SvgPicture.asset(
            Images.profile_thumb,
            height: Dimensions.getConvertedHeightSize(context, 79),
            width: Dimensions.getConvertedHeightSize(context, 79),
            color: CardioColors.grey_06,
          ),
          SizedBox(
            width: Dimensions.getConvertedWidthSize(context, 10),
          ),

          /// Personal data
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _fullname,
                  style: TextStyle(
                    fontSize: Dimensions.getTextSize(context, 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  userCpf,
                  style: TextStyle(
                    fontSize: Dimensions.getTextSize(context, 16),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenuExitButton extends StatelessWidget {
  const SideMenuExitButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: Dimensions.getEdgeInsets(
            context,
            left: 20,
            top: 10,
            bottom: 10,
          ),
          width: Dimensions.getConvertedWidthSize(context, 100),
          child: Text(
            Strings.exit_button_side_menu_item,
            style: TextStyle(
              color: CardioColors.black,
              fontSize: Dimensions.getTextSize(context, 20),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: () {
          Mixpanel.trackEvent(MixpanelEvents.DO_LOGOUT);
          BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
          Navigator.of(context).pushNamedAndRemoveUntil("/", (r) => false);
        });
  }
}

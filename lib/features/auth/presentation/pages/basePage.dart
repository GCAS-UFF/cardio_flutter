import 'dart:ui';

import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/core/widgets/side_menu_exit_button.dart';
import 'package:cardio_flutter/core/widgets/side_menu_header.dart';
import 'package:cardio_flutter/core/widgets/side_menu_item.dart';
import 'package:cardio_flutter/features/auth/domain/entities/user.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  final Widget body;
  final Widget edit;
  final Color backgroundColor;
  final bool signOutButton;
  final Function addFunction;
  final User userData;
  final String recomendation;

  const BasePage({
    Key key,
    this.body,
    this.edit,
    this.backgroundColor,
    this.signOutButton = true,
    this.addFunction,
    this.userData,
    this.recomendation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
      fontSize: Dimensions.getTextSize(context, 22),
      color: CardioColors.white,
      fontWeight: FontWeight.w500,
    );
    return Scaffold(
      floatingActionButton: (addFunction != null)
          ? ((Provider.of<Settings>(context, listen: false).getUserType() ==
                  Keys.PROFESSIONAL_TYPE)
              ? FloatingActionButton(
                  onPressed: addFunction,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.lightBlueAccent[200],
                )
              : null)
          : null,
      body: body,
      backgroundColor: CardioColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: CardioColors.white,
        ),
        title: userData != null
            ? RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: Strings.greeting_text_app_bar,
                      style: _textStyle,
                    ),
                    TextSpan(
                      text: userData.type,
                      style: _textStyle,
                    ),
                    TextSpan(
                      text: Strings.exclamation_point_text_app_bar,
                      style: _textStyle,
                    ),
                  ],
                ),
              )
            : Text(
                recomendation,
                style: _textStyle,
              ),
        backgroundColor: CardioColors.blue,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            width: Dimensions.getConvertedWidthSize(context, 260),
            padding: Dimensions.getEdgeInsets(context, bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Header
                SideMenuHeader(),
                SizedBox(
                  height: Dimensions.getConvertedHeightSize(context, 35),
                ),
                SideMenuItem(),
                SideMenuItem(),

                /// Spacer
                Expanded(
                  flex: 1,
                  child: Container(),
                ),

                /// Exit button
                SideMenuExitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

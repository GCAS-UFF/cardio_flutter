import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/orientations/widgets/clickable_item.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

class AppInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      key: UniqueKey(),
      onFocusGained: () {
        Mixpanel.trackEvent(
          MixpanelEvents.OPEN_PAGE,
          data: {"pageTittle": "AppInfoPage"},
        );
      },
      child: BasePage(
        recomendation: Strings.about,
        body: SingleChildScrollView(
          child: Container(
            margin: Dimensions.getEdgeInsets(context, left: 15, top: 30),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClickableItem(
                    title: Strings.about1,
                    text: TextSpan(text: Strings.about_answer1),
                    event: MixpanelEvents.OPEN_HELP_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.about2,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: Strings.about2_1,
                          style: TextStyle(
                            fontSize: Dimensions.getTextSize(context, 22),
                            color: CardioColors.blue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: Strings.about_answer2_1,
                        ),
                        TextSpan(
                          text: Strings.about2_2,
                          style: TextStyle(
                            fontSize: Dimensions.getTextSize(context, 22),
                            color: CardioColors.blue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: Strings.about_answer2_2,
                        ),
                        TextSpan(
                          text: Strings.about2_3,
                          style: TextStyle(
                            fontSize: Dimensions.getTextSize(context, 22),
                            color: CardioColors.blue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: Strings.about_answer2_3,
                        ),
                      ],
                    ),
                    event: MixpanelEvents.OPEN_HELP_ITEM,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

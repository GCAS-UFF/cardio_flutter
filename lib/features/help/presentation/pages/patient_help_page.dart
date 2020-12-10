import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/orientations/widgets/clickable_item.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

class PatientHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      key: UniqueKey(),
      onFocusGained: () {
        Mixpanel.trackEvent(
          MixpanelEvents.OPEN_PAGE,
          data: {"pageTittle": "PatientHelpPage"},
        );
      },
      child: BasePage(
        recomendation: Strings.help,
        body: SingleChildScrollView(
          child: Container(
            margin: Dimensions.getEdgeInsets(context, left: 15, top: 30),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ClickableItem(
                    title: Strings.help1,
                    text: TextSpan(text: Strings.help_answer1),
                    event: MixpanelEvents.OPEN_HELP_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.help2,
                    text: TextSpan(text: Strings.help_answer2),
                    event: MixpanelEvents.OPEN_HELP_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.help3,
                    text: TextSpan(text: Strings.help_answer3),
                    event: MixpanelEvents.OPEN_HELP_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.help4,
                    text: TextSpan(text: Strings.help_answer4),
                    event: MixpanelEvents.OPEN_HELP_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.help5,
                    text: TextSpan(text: Strings.help_answer5),
                    event: MixpanelEvents.OPEN_HELP_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.help6,
                    text: TextSpan(text: Strings.help_answer6),
                    event: MixpanelEvents.OPEN_HELP_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.help7,
                    text: TextSpan(text: Strings.help_answer7),
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

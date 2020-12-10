import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/orientations/widgets/clickable_item.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class ProfessionalHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      recomendation: Strings.help,
      body: SingleChildScrollView(
        child: Container(
          margin: Dimensions.getEdgeInsets(context, left: 15, top: 30),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClickableItem(
                  title: Strings.professional_help1,
                  text: TextSpan(text: Strings.professional_help_answer1),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
                ClickableItem(
                  title: Strings.professional_help2,
                  text: TextSpan(text: Strings.professional_help_answer2),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
                ClickableItem(
                  title: Strings.professional_help3,
                  text: TextSpan(text: Strings.professional_help_answer3),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
                ClickableItem(
                  title: Strings.professional_help4,
                  text: TextSpan(text: Strings.professional_help_answer4),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
                ClickableItem(
                  title: Strings.professional_help5,
                  text: TextSpan(text: Strings.professional_help_answer5),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
                ClickableItem(
                  title: Strings.professional_help6,
                  text: TextSpan(text: Strings.professional_help_answer6),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
                ClickableItem(
                  title: Strings.professional_help7,
                  text: TextSpan(text: Strings.professional_help_answer7),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
                ClickableItem(
                  title: Strings.professional_help8,
                  text: TextSpan(text: Strings.professional_help_answer8),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
                ClickableItem(
                  title: Strings.professional_help9,
                  text: TextSpan(text: Strings.professional_help_answer9),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
                ClickableItem(
                  title: Strings.professional_help10,
                  text: TextSpan(text: Strings.professional_help_answer10),
                  event: MixpanelEvents.OPEN_HELP_ITEM,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

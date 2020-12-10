import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/orientations/widgets/clickable_item.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

class OrientationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      key: UniqueKey(),
      onFocusGained: () {
        Mixpanel.trackEvent(
          MixpanelEvents.OPEN_PAGE,
          data: {"pageTittle": "OrientationsPage"},
        );
      },
      child: BasePage(
        recomendation: Strings.orientations,
        body: SingleChildScrollView(
          child: Container(
            margin: Dimensions.getEdgeInsets(context, left: 15, top: 30),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ClickableItem(
                    title: Strings.orientation1,
                    text: TextSpan(text: Strings.orientation_answer1),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation2,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Importante:",
                          style: TextStyle(
                            color: CardioColors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: Strings.orientation_answer2),
                      ],
                    ),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation3,
                    text: TextSpan(
                      children: [
                        TextSpan(text: Strings.orientation_answer3_1),
                        TextSpan(
                          text: "Evite",
                          style: TextStyle(
                            color: CardioColors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: Strings.orientation_answer3_2),
                        TextSpan(
                          text: "Prefira temperos naturais:  ",
                          style: TextStyle(
                            color: CardioColors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: Strings.orientation_answer3_3),
                      ],
                    ),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation4,
                    text: TextSpan(text: Strings.orientation_answer4),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation5,
                    text: TextSpan(text: Strings.orientation_answer5),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation6,
                    text: TextSpan(text: Strings.orientation_answer6),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation7,
                    text: TextSpan(text: Strings.orientation_answer7),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation8,
                    text: TextSpan(text: Strings.orientation_answer8),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation9,
                    text: TextSpan(text: Strings.orientation_answer9),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation10,
                    text: TextSpan(text: Strings.orientation_answer10),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation11,
                    text: TextSpan(text: Strings.orientation_answer11),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation12,
                    text: TextSpan(
                      children: [
                        TextSpan(text: Strings.orientation_answer12_1),
                        TextSpan(
                          text: " Para diminuir a ansiedade: ",
                          style: TextStyle(
                            color: CardioColors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: Strings.orientation_answer12_2),
                      ],
                    ),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation13,
                    text: TextSpan(text: Strings.orientation_answer13),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
                  ),
                  ClickableItem(
                    title: Strings.orientation14,
                    text: TextSpan(text: Strings.orientation_answer14),
                    event: MixpanelEvents.OPEN_ORIENTATION_ITEM,
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

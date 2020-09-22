import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/orientations/widgets/clickable_item.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class OrientationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
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
                ),
                ClickableItem(
                  title: Strings.orientation4,
                  text: TextSpan(text: Strings.orientation_answer4),
                ),
                ClickableItem(
                  title: Strings.orientation5,
                  text: TextSpan(text: Strings.orientation_answer5),
                ),
                ClickableItem(
                  title: Strings.orientation6,
                  text: TextSpan(text: Strings.orientation_answer6),
                ),
                ClickableItem(
                  title: Strings.orientation7,
                  text: TextSpan(text: Strings.orientation_answer7),
                ),
                ClickableItem(
                  title: Strings.orientation8,
                  text: TextSpan(text: Strings.orientation_answer8),
                ),
                ClickableItem(
                  title: Strings.orientation9,
                  text: TextSpan(text: Strings.orientation_answer9),
                ),
                ClickableItem(
                  title: Strings.orientation10,
                  text: TextSpan(text: Strings.orientation_answer10),
                ),
                ClickableItem(
                  title: Strings.orientation11,
                  text: TextSpan(text: Strings.orientation_answer11),
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
                ),
                ClickableItem(
                    title: Strings.orientation13,
                    text: TextSpan(text: Strings.orientation_answer13)),
                ClickableItem(
                  title: Strings.orientation14,
                  text: TextSpan(text: Strings.orientation_answer14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

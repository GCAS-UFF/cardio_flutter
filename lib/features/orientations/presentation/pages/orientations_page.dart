import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/orientations/widgets/clickable_item.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class OrientationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              ClickableItem(
                  title: Strings.orientation1,
                  text: Strings.orientation_answer1),
              RichClickableItem(
                title: Strings.orientation2,
                text: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Importante: ",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      TextSpan(text: Strings.orientation_answer2),
                    ],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.getTextSize(context, 13),
                    ),
                  ),
                ),
              ),
              RichClickableItem(
                title: Strings.orientation3,
                text: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(text: Strings.orientation_answer3_1),
                      TextSpan(
                          text: " EVITE ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      TextSpan(text: Strings.orientation_answer3_2),
                      TextSpan(
                        text: "Prefira temperos naturais:  ",
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: Strings.orientation_answer3_3),
                    ],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.getTextSize(context, 13),
                    ),
                  ),
                ),
              ),
              ClickableItem(
                  title: Strings.orientation4,
                  text: Strings.orientation_answer4),
              ClickableItem(
                  title: Strings.orientation5,
                  text: Strings.orientation_answer5),
              ClickableItem(
                  title: Strings.orientation6,
                  text: Strings.orientation_answer6),
              ClickableItem(
                  title: Strings.orientation7,
                  text: Strings.orientation_answer7),
              ClickableItem(
                  title: Strings.orientation8,
                  text: Strings.orientation_answer8),
              ClickableItem(
                  title: Strings.orientation9,
                  text: Strings.orientation_answer9),
              ClickableItem(
                  title: Strings.orientation10,
                  text: Strings.orientation_answer10),
              ClickableItem(
                  title: Strings.orientation11,
                  text: Strings.orientation_answer11),
              RichClickableItem(
                title: Strings.orientation12,
                text: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    children: [
                      TextSpan(text: Strings.orientation_answer12_1),
                      TextSpan(
                        text: " Para diminuir a ansiedade: ",
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: Strings.orientation_answer12_2),
                    ],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.getTextSize(context, 13),
                    ),
                  ),
                ),
              ),
              ClickableItem(
                  title: Strings.orientation13,
                  text: Strings.orientation_answer13),
              ClickableItem(
                  title: Strings.orientation14,
                  text: Strings.orientation_answer14),
              
            ],
          ),
        ),
      ),
    );
  }
}

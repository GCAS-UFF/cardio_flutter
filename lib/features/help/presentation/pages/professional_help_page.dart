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
                ),
                ClickableItem(
                  title: Strings.professional_help2,
                  text: TextSpan(text: Strings.professional_help_answer2),
                ),
                ClickableItem(
                  title: Strings.professional_help3,
                  text: TextSpan(text: Strings.professional_help_answer3),
                ),
                ClickableItem(
                  title: Strings.professional_help4,
                  text: TextSpan(text: Strings.professional_help_answer4),
                ),
                ClickableItem(
                  title: Strings.professional_help5,
                  text: TextSpan(text: Strings.professional_help_answer5),
                ),
                ClickableItem(
                  title: Strings.professional_help6,
                  text: TextSpan(text: Strings.professional_help_answer6),
                ),
                ClickableItem(
                  title: Strings.professional_help7,
                  text: TextSpan(text: Strings.professional_help_answer7),
                ),
                ClickableItem(
                  title: Strings.professional_help8,
                  text: TextSpan(text: Strings.professional_help_answer8),
                ),
                ClickableItem(
                  title: Strings.professional_help9,
                  text: TextSpan(text: Strings.professional_help_answer9),
                ),
                ClickableItem(
                  title: Strings.professional_help10,
                  text: TextSpan(text: Strings.professional_help_answer10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/orientations/widgets/clickable_item.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class PatientHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      recomendation: Strings.help,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              ClickableItem(
                  title: Strings.help1,
                  text: TextSpan(text: Strings.help_answer1)),
              ClickableItem(
                  title: Strings.help2,
                  text: TextSpan(text: Strings.help_answer2)),
              ClickableItem(
                  title: Strings.help3,
                  text: TextSpan(text: Strings.help_answer3)),
              ClickableItem(
                  title: Strings.help4,
                  text: TextSpan(text: Strings.help_answer4)),
              ClickableItem(
                  title: Strings.help5,
                  text: TextSpan(text: Strings.help_answer5)),
              ClickableItem(
                  title: Strings.help6,
                  text: TextSpan(text: Strings.help_answer6)),
              ClickableItem(
                  title: Strings.help7,
                  text: TextSpan(text: Strings.help_answer7)),
            ],
          ),
        ),
      ),
    );
  }
}

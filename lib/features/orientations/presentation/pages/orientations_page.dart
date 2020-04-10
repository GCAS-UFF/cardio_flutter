import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/orientations/widgets/clickable_item.dart';
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
              ClickableItem(title: Strings.orientation1, text: Strings.orientation_answer1),
              ClickableItem(title: Strings.orientation2, text: Strings.orientation_answer2),
              ClickableItem(title: Strings.orientation3, text: Strings.orientation_answer3),
              ClickableItem(title: Strings.orientation4, text: Strings.orientation_answer4),
              ClickableItem(title: Strings.orientation5, text: Strings.orientation_answer5),
              ClickableItem(title: Strings.orientation6, text: Strings.orientation_answer6),
              ClickableItem(title: Strings.orientation7, text: Strings.orientation_answer7),
              ClickableItem(title: Strings.orientation8, text: Strings.orientation_answer8),
              ClickableItem(title: Strings.orientation9, text: Strings.orientation_answer9),
              ClickableItem(title: Strings.orientation10, text: Strings.orientation_answer10),
              ClickableItem(title: Strings.orientation11, text: Strings.orientation_answer11),
              ClickableItem(title: Strings.orientation12, text: Strings.orientation_answer12),
              ClickableItem(title: Strings.orientation13, text: Strings.orientation_answer13),
              ClickableItem(title: Strings.orientation14, text: Strings.orientation_answer14),
              ClickableItem(title: Strings.orientation15, text: Strings.orientation_answer15),
              ClickableItem(title: Strings.orientation16, text: Strings.orientation_answer16),
              ClickableItem(title: Strings.orientation17, text: Strings.orientation_answer17),
              ClickableItem(title: Strings.orientation18, text: Strings.orientation_answer18),
              ClickableItem(title: Strings.orientation19, text: Strings.orientation_answer19),
              ClickableItem(title: Strings.orientation20, text: Strings.orientation_answer20),
            ],
          ),
        ),
      ),
    );
  }
}

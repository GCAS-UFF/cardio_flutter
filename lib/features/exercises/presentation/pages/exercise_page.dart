import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';

import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      addFunction: (){
        Navigator.pushNamed(context, "/addExercisePage");
      },
      body: Container(

      ),
    );
  }
}

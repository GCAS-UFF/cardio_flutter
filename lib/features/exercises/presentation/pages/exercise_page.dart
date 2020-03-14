
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/add_exercise_page.dart';

import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BasePage(
      addFunction: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExercisePage()));
      },
      body: Container(

      ),
    );
  }
}

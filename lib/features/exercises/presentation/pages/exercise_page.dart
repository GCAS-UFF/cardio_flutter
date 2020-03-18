import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart';
import 'package:cardio_flutter/features/exercises/presentation/pages/add_exercise_page.dart';
import 'package:cardio_flutter/features/exercises/presentation/widgets/exercise_card.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      addFunction: () {
        (Provider.of<Settings>(context, listen: false).getUserType() ==
                Keys.PROFESSIONAL_TYPE)
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddExercisePage()))
            :null;
      },
      backgroundColor: Color(0xffc9fffd),
      body: BlocListener<ExerciseBloc, ExerciseState>(
        listener: (context, state) {
          if (state is Error) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocBuilder<ExerciseBloc, ExerciseState>(
          builder: (context, state) {
            if (state is Loading) {
              return LoadingWidget(_bodybuilder(context, null, null));
            } else if (state is Loaded) {
              return _bodybuilder(context, state.patient, state.exerciseList);
            } else {
              return _bodybuilder(context, null, null);
            }
          },
        ),
      ),
    );
  }

  Widget _buildExerciseList(BuildContext context, List<Exercise> exerciseList) {
    if (exerciseList == null) return Container();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: exerciseList.map((exercise) {
        return ExerciseCard(
          exercise: exercise,
        );
      }).toList(),
    );
  }

  Widget _bodybuilder(
      BuildContext context, Patient patient, List<Exercise> exerciseList) {
    return Container(
      child: SingleChildScrollView(
        padding: Dimensions.getEdgeInsetsAll(context, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(10),
              ),
              height: Dimensions.getConvertedHeightSize(context, 50),
              alignment: Alignment.center,
              child: Text(
                "Março de 2020",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            SizedBox(
              height: Dimensions.getConvertedHeightSize(context, 10),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "seg".toUpperCase(),
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                    Container(
                      child: CircleAvatar(
                        backgroundColor: Colors.blue[900],
                        radius: 35,
                        child: Text(
                          (DateHelper.convertDateToString(DateTime.now())
                              .substring(0, 2)),
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: Dimensions.getConvertedWidthSize(context, 15),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _buildExerciseList(context, exerciseList),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

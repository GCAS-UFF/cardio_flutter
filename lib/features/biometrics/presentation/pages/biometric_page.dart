import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/biometrics/presentation/pages/add_biometric_page.dart';
import 'package:cardio_flutter/features/biometrics/presentation/pages/execute_biometric_page.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/calendar.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/day.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/month.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/widgets/empty_page.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/widgets/entity_card.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BiometricPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      recomendation: Strings.biometric,
      addFunction: () {
        if (Provider.of<Settings>(context, listen: false).getUserType() ==
            Keys.PROFESSIONAL_TYPE) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBiometricPage(),
            ),
          );
        }
      },
      body: BlocListener<GenericBloc<Biometric>, GenericState<Biometric>>(
        listener: (context, state) {
          if (state is Error<Biometric>) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocBuilder<GenericBloc<Biometric>, GenericState<Biometric>>(
          builder: (context, state) {
            if (state is Loading<Biometric>) {
              return LoadingWidget(Container());
            } else if (state is Loaded<Biometric>) {
              return _bodybuilder(context, state.patient, state.calendar);
            } else {
              return _bodybuilder(context, null, null);
            }
          },
        ),
      ),
    );
  }

  Widget _buildExerciseList(BuildContext context, List<Activity> activityList) {
    if (activityList == null) return Container();
    return Column(
      children: activityList.map((activity) {
        return EntityCard(
          activity: activity,
          openExecuted: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExecuteBiometricPage(
                  biometric: activity.value,
                ),
              ),
            );
          },
          delete: () {
            BlocProvider.of<GenericBloc<Biometric>>(context).add(
              DeleteEvent<Biometric>(
                entity: activity.value,
              ),
            );
          },
          openRecomendation: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBiometricPage(
                  biometric: activity.value,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildMonthList(BuildContext context, List<Month> monthList) {
    if (monthList == null) return Container();
    return Column(
      children: monthList.map((month) {
        return Column(
          children: <Widget>[
            Container(
              padding: Dimensions.getEdgeInsets(context, bottom: 5),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                color: CardioColors.white,
                border: Border(
                  bottom: BorderSide(
                    color: CardioColors.black,
                    width: Dimensions.getConvertedHeightSize(context, 1),
                  ),
                ),
              ),
              child: Text(
                "${Arrays.months[month.id - 1]} ${month.year}",
                style: TextStyle(
                  color: CardioColors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: Dimensions.getTextSize(context, 22),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.getConvertedHeightSize(context, 15),
            ),
            _buildDayList(
              context,
              month.days,
            )
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDayList(BuildContext context, List<Day> dayList) {
    if (dayList == null) return Container();
    return Column(
      children: dayList.map((day) {
        return Container(
          margin: Dimensions.getEdgeInsets(context, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: CardioColors.blue,
                radius: Dimensions.getConvertedHeightSize(context, 25),
                child: Text(
                  day.id.toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: CardioColors.white,
                  ),
                ),
              ),
              SizedBox(
                width: Dimensions.getConvertedWidthSize(context, 10),
              ),
              Expanded(
                child: _buildExerciseList(context, day.activities),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _bodybuilder(
      BuildContext context, Patient patient, Calendar calendar) {
    if (patient == null ||
        calendar == null ||
        calendar.months == null ||
        calendar.months.isEmpty)
      return EmptyPage(text: Strings.empty_biometrics);
    return Container(
      margin: Dimensions.getEdgeInsets(context, left: 15),
      child: SingleChildScrollView(
        padding: Dimensions.getEdgeInsetsAll(context, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: Dimensions.getConvertedHeightSize(context, 10),
            ),
            Column(
              children: <Widget>[
                _buildMonthList(context, calendar.months),
              ],
            ),
            SizedBox(
              width: Dimensions.getConvertedWidthSize(context, 15),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/appointments/presentation/pages/add_appointment_page.dart';
import 'package:cardio_flutter/features/appointments/presentation/pages/execute_appointment_page.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/calendar.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/day.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/month.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/widgets/empty_page.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/widgets/entity_card.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      addFunction: () {
        if (Provider.of<Settings>(context, listen: false).getUserType() ==
            Keys.PROFESSIONAL_TYPE) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddAppointmentPage()));
        }
      },
      backgroundColor: Color(0xffc9fffd),
      body: BlocListener<GenericBloc<Appointment>, GenericState<Appointment>>(
        listener: (context, state) {
          if (state is Error<Appointment>) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocBuilder<GenericBloc<Appointment>, GenericState<Appointment>>(
          builder: (context, state) {
            if (state is Loading<Appointment>) {
              return LoadingWidget(Container());
            } else if (state is Loaded<Appointment>) {
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
                builder: (context) => ExecuteAppointmentPage(
                  appointment: activity.value,
                ),
              ),
            );
          },
          delete: () {
            BlocProvider.of<GenericBloc<Appointment>>(context).add(
              DeleteEvent<Appointment>(
                entity: activity.value,
              ),
            );
          },
          openRecomendation: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAppointmentPage(
                  appointment: activity.value,
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
    monthList.sort((b, a) => '${a.year}${a.id}'.compareTo('${b.year}${b.id}'));
    return Column(
      children: monthList.map((month) {
        return Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(10),
              ),
              height: Dimensions.getConvertedHeightSize(context, 50),
              alignment: Alignment.center,
              child: Text(
                "${Arrays.months[month.id - 1]} ${month.year}",
                style: TextStyle(fontSize: 20, color: Colors.white),
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
    dayList.sort((b, a) => a.id.compareTo(b.id));
    return Column(
      children: dayList.map((day) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: CircleAvatar(
                backgroundColor: Colors.blue[900],
                radius: 35,
                child: Text(
                  (day.id.toString()),
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            SizedBox(
              width: Dimensions.getConvertedWidthSize(context, 15),
            ),
            Expanded(child: _buildExerciseList(context, day.activities)),
          ],
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
      return EmptyPage(text: Strings.empty_appointment);
    return Container(
      child: SingleChildScrollView(
        padding: Dimensions.getEdgeInsetsAll(context, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: Dimensions.getConvertedHeightSize(context, 10),
            ),
            Column(
              children: <Widget>[_buildMonthList(context, calendar.months)],
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

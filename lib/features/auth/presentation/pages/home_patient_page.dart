import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/app_info/presentation/pages/app_info_page.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart'
    as exercise;
import 'package:cardio_flutter/features/help/presentation/pages/patient_help_page.dart';
import 'package:cardio_flutter/features/help/presentation/pages/professional_help_page.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:cardio_flutter/features/orientations/presentation/pages/orientations_page.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/core/widgets/menu_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart'
    as generic;

class HomePatientPage extends StatelessWidget {
  final Patient patient;

  const HomePatientPage({
    @required this.patient,
  });
  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.blue[900],
      body: SingleChildScrollView(
        child: Container(
          width: Dimensions.getConvertedWidthSize(context, 412),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: Dimensions.getEdgeInsetsAll(context, 8),
                child: Text(
                  "Paciente: ${(patient != null || patient.name != null) ? patient.name : ""}\nIdade: ${(patient != null) ? DateHelper.ageFromDate(patient.birthdate) : ""}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.getTextSize(context, 13),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ItemMenu(
                text: Strings.biometric,
                image: Images.ico_biometric,
                destination: () {
                  BlocProvider.of<generic.GenericBloc<Biometric>>(context)
                      .add(generic.Start<Biometric>(patient: patient));
                  return Navigator.pushNamed(context, "/biometricPage");
                },
              ),
              ItemMenu(
                text: Strings.liquid,
                image: Images.ico_liquid,
                destination: () {
                  BlocProvider.of<generic.GenericBloc<Liquid>>(context)
                      .add(generic.Start<Liquid>(patient: patient));
                  return Navigator.pushNamed(context, "/liquidPage");
                },
              ),
              ItemMenu(
                text: Strings.medication,
                image: Images.ico_medication,
                destination: () {
                  BlocProvider.of<generic.GenericBloc<Medication>>(context)
                      .add(generic.Start<Medication>(patient: patient));
                  return Navigator.pushNamed(context, "/medicationPage");
                },
              ),
              ItemMenu(
                text: Strings.appointment,
                image: Images.ico_appointment,
                destination: () {
                  BlocProvider.of<generic.GenericBloc<Appointment>>(context)
                      .add(generic.Start<Appointment>(patient: patient));
                  return Navigator.pushNamed(context, "/appointmentPage");
                },
              ),
              ItemMenu(
                text: Strings.exercise,
                image: Images.ico_exercise,
                destination: () {
                  BlocProvider.of<exercise.ExerciseBloc>(context)
                      .add(exercise.Start(patient: patient));
                  return Navigator.pushNamed(context, "/exercisePage");
                },
              ),
              ItemMenu(
                text: Strings.orientations,
                image: Images.ico_orientations,
                destination: () {
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrientationsPage()));
                },
              ),
              ItemMenu(
                text: Strings.about,
                image: Images.ico_about,
                destination: () {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AppInfoPage()));
                },
              ),
              ItemMenu(
                text: Strings.help,
                image: Images.ico_help,
                destination: () {
                  (Provider.of<Settings>(context, listen: false)
                              .getUserType() ==
                          Keys.PROFESSIONAL_TYPE)
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfessionalHelpPage()))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientHelpPage()));
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}

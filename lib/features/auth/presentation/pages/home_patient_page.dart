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
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/core/widgets/menu_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart'
    as generic;

class HomePatientPage extends StatelessWidget {
  final Patient patient;

  const HomePatientPage({
    @required this.patient,
  });
  @override
  Widget build(BuildContext context) {
    debugPrint("[JP] ${patient?.name?.split(" ")[0]}");
    return BasePage(
      hasDrawer: true,
      recomendation: "Home",
      patient: patient,
      body: SingleChildScrollView(
        child: Container(
          width: Dimensions.getConvertedWidthSize(context, 412),
          padding: Dimensions.getEdgeInsets(context, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// Patient data
              Visibility(
                visible: false,
                child: Container(
                  width: double.infinity,
                  margin: Dimensions.getEdgeInsets(context, left: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CardioColors.black,
                        width: Dimensions.getConvertedHeightSize(context, 1),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        (patient != null || patient.name != null)
                            ? patient.name
                            : "Null",
                        style: TextStyle(
                          color: CardioColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: Dimensions.getTextSize(context, 20),
                        ),
                      ),
                      Text(
                        (patient != null || patient.cpf != null)
                            ? "CPF: ${patient.cpf}"
                            : "Null",
                        style: TextStyle(
                          color: CardioColors.black,
                          fontSize: Dimensions.getTextSize(context, 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),

              /// Biometric data item
              ItemMenu(
                text: Strings.biometric,
                image: Images.ico_biometric,
                destination: () {
                  BlocProvider.of<generic.GenericBloc<Biometric>>(context).add(
                    generic.Start<Biometric>(patient: patient),
                  );
                  return Navigator.pushNamed(context, "/biometricPage");
                },
              ),

              /// Liquid intake item
              ItemMenu(
                text: Strings.ingested_liquids,
                image: Images.ico_liquid,
                destination: () {
                  BlocProvider.of<generic.GenericBloc<Liquid>>(context).add(
                    generic.Start<Liquid>(patient: patient),
                  );
                  return Navigator.pushNamed(context, "/liquidPage");
                },
              ),

              /// Medication item
              ItemMenu(
                text: Strings.medication,
                image: Images.ico_medication,
                destination: () {
                  BlocProvider.of<generic.GenericBloc<Medication>>(context).add(
                    generic.Start<Medication>(patient: patient),
                  );
                  return Navigator.pushNamed(context, "/medicationPage");
                },
              ),

              /// Appointments item
              ItemMenu(
                text: Strings.appointment,
                image: Images.ico_appointment,
                destination: () {
                  BlocProvider.of<generic.GenericBloc<Appointment>>(context)
                      .add(
                    generic.Start<Appointment>(patient: patient),
                  );
                  return Navigator.pushNamed(context, "/appointmentPage");
                },
              ),

              /// Excercises item
              ItemMenu(
                text: Strings.exercise,
                image: Images.ico_exercise,
                destination: () {
                  BlocProvider.of<exercise.ExerciseBloc>(context).add(
                    exercise.Start(patient: patient),
                  );
                  return Navigator.pushNamed(context, "/exercisePage");
                },
              ),

              /// Orientations item
              ItemMenu(
                text: Strings.orientations,
                image: Images.ico_orientations,
                destination: () {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrientationsPage(),
                    ),
                  );
                },
              ),

              /*
              ItemMenu(
                text: Strings.about,
                image: Images.ico_about,
                destination: () {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppInfoPage(),
                    ),
                  );
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
                            builder: (context) => ProfessionalHelpPage(),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientHelpPage(),
                          ),
                        );
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 15),
              )
              */
            ],
          ),
        ),
      ),
    );
  }
}

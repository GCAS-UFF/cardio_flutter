import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
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
import 'package:focus_detector/focus_detector.dart';

class HomePatientPage extends StatefulWidget {
  final Patient patient;

  const HomePatientPage({
    @required this.patient,
  });

  @override
  _HomePatientPageState createState() => _HomePatientPageState();
}

class _HomePatientPageState extends State<HomePatientPage> {
  final _resumeDetectorKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      key: _resumeDetectorKey,
      onFocusGained: () {
        Mixpanel.trackEvent(
          MixpanelEvents.OPEN_PAGE,
          data: {"pageTitle": "HomePatientPage"},
        );
      },
      child: BasePage(
        hasDrawer: true,
        recomendation: "Home",
        patient: widget.patient,
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
                          (widget.patient != null ||
                                  widget.patient.name != null)
                              ? widget.patient.name
                              : "Null",
                          style: TextStyle(
                            color: CardioColors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.getTextSize(context, 20),
                          ),
                        ),
                        Text(
                          (widget.patient != null || widget.patient.cpf != null)
                              ? "CPF: ${widget.patient.cpf}"
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
                    BlocProvider.of<generic.GenericBloc<Biometric>>(context)
                        .add(generic.Start<Biometric>(patient: widget.patient));
                    Mixpanel.trackEvent(
                      MixpanelEvents.OPEN_HISTORY,
                      data: {"actionType": "biometric"},
                    );
                    return Navigator.pushNamed(context, "/biometricPage");
                  },
                ),

                /// Liquid intake item
                ItemMenu(
                  text: Strings.ingested_liquids,
                  image: Images.ico_liquid,
                  destination: () {
                    BlocProvider.of<generic.GenericBloc<Liquid>>(context)
                        .add(generic.Start<Liquid>(patient: widget.patient));
                    Mixpanel.trackEvent(
                      MixpanelEvents.OPEN_HISTORY,
                      data: {"actionType": "liquid"},
                    );
                    return Navigator.pushNamed(context, "/liquidPage");
                  },
                ),

                /// Medication item
                ItemMenu(
                  text: Strings.medication,
                  image: Images.ico_medication,
                  destination: () {
                    BlocProvider.of<generic.GenericBloc<Medication>>(context)
                        .add(
                            generic.Start<Medication>(patient: widget.patient));
                    Mixpanel.trackEvent(
                      MixpanelEvents.OPEN_HISTORY,
                      data: {"actionType": "medication"},
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
                        .add(generic.Start<Appointment>(
                            patient: widget.patient));
                    Mixpanel.trackEvent(
                      MixpanelEvents.OPEN_HISTORY,
                      data: {"actionType": "appointment"},
                    );
                    return Navigator.pushNamed(context, "/appointmentPage");
                  },
                ),

                /// Excercises item
                ItemMenu(
                  text: Strings.exercise,
                  image: Images.ico_exercise,
                  destination: () {
                    BlocProvider.of<generic.GenericBloc<Exercise>>(context)
                        .add(generic.Start<Exercise>(patient: widget.patient));
                    Mixpanel.trackEvent(
                      MixpanelEvents.OPEN_HISTORY,
                      data: {"actionType": "exercise"},
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
                          builder: (context) => OrientationsPage()),
                    );
                  },
                ),

                /*
                ItemMenu(
                  text: Strings.about,
                  image: Images.ico_about,
                  destination: () {
                    Mixpanel.trackEvent(MixpanelEvents.READ_INFORMATION);
                    return Navigator.push(context, MaterialPageRoute(builder: (context) => AppInfoPage()));
                  },
                ),
                ItemMenu(
                  text: Strings.help,
                  image: Images.ico_help,
                  destination: () {
                    Mixpanel.trackEvent(MixpanelEvents.READ_QUESTIONS);
                    (Provider.of<Settings>(context, listen: false).getUserType() == Keys.PROFESSIONAL_TYPE)
                        ? Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalHelpPage()))
                        : Navigator.push(context, MaterialPageRoute(builder: (context) => PatientHelpPage()));
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
      ),
    );
  }
}

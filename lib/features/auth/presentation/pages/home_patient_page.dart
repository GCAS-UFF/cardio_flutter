import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/core/widgets/menu_item.dart';

class HomePatientPage extends StatelessWidget {
  final Patient patient;

  const HomePatientPage({ @required this.patient}) ;
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
                  "Paciente: ${(patient!=null)?patient.name:""}\nIdade: ${(patient!=null)?patient.name:""}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.getTextSize(context, 13),
                      fontWeight: FontWeight.bold),
                ),
              ),
              ItemMenu(
                text: Strings.biometric,
                image: Images.ico_biometric,
                destination: () {
                  return Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePatientPage(patient: patient)));
                },
              ),
              ItemMenu(
                text: Strings.liquid,
                image: Images.ico_liquid,
                destination: () {
                                    return Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePatientPage(patient: patient)));

                },
              ),
              ItemMenu(
                text: Strings.medicine,
                image: Images.ico_medicine,
                destination: () {
                                    return Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePatientPage(patient: patient)));

                },
              ),
              ItemMenu(
                text: Strings.appointment,
                image: Images.ico_appointment,
                destination: () {
                                    return Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePatientPage(patient: patient)));

                },
              ),
              ItemMenu(
                text: Strings.exercise,
                image: Images.ico_exercise,
                destination: () {
                  return Navigator.pushNamed(context, "/exercisePage");
                },
              ),
              ItemMenu(
                text: Strings.orientations,
                image: Images.ico_orientations,
                destination: () {
                  return Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePatientPage(patient: patient)));
                  
                },
              ),
              ItemMenu(
                text: Strings.about,
                image: Images.ico_about,
                destination: () {
                                    return Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePatientPage(patient: patient)));

                },
              ),
              ItemMenu(
                text: Strings.help,
                image: Images.ico_help,
                destination: () {
                                    return Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePatientPage(patient: patient)));

                },
              ),
              SizedBox(height: Dimensions.getConvertedHeightSize(context, 15),)
            ],
          ),
        ),
      ),
    );
  }
}

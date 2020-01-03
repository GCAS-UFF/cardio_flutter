import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';

class PatientSignUpPage extends StatefulWidget {
  @override
  _PatientSignUpPageState createState() => _PatientSignUpPageState();
}

class _PatientSignUpPageState extends State<PatientSignUpPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffc9fffd),
        appBar: AppBar(
          actions: <Widget>[Icon(Icons.exit_to_app), Text("    ")],
          title: Text(
            Strings.app_name,
            style: TextStyle(fontSize: Dimensions.getTextSize(context, 20)),
          ),
          backgroundColor: Colors.lightBlueAccent[100],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 10),
              ),
              CustomTextFormField(
                hintText: Strings.name_hint,
                title: Strings.name_title,
              ),
              CustomTextFormField(
                hintText: Strings.cpf_hint,
                title: Strings.cpf_title,
              ),
              CustomTextFormField(
                hintText: "",
                title: Strings.adress,
              ),
              CustomTextFormField(
                hintText: "",
                title: Strings.birth,
              ),
              CustomTextFormField(
                hintText: Strings.email_hint,
                title: Strings.email_title,
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/homePage");
                },
                child: Button(
                  title: Strings.new_patient_done,
                  onTap: () {
                    Navigator.pushNamed(context, "/homePage");
                  },
                ),
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
            ],
          ),
        ));
  }
}

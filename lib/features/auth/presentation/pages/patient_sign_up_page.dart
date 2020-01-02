import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/home_page.dart';
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
        title: Text(Strings.app_name, style: TextStyle(fontSize: Dimensions.getTextSize(context, 20)),),
        backgroundColor: Colors.lightBlueAccent[100],
      ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: Dimensions.getConvertedHeightSize(context, 10),),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return HomePage();
                  }));
                },
                child: Button( title: Strings.new_patient_done, onTap: () {
                  Navigator.pushNamed(context, "/homePage");
                },)
                
                
                 /*Container(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.green,
                        offset: Offset(3, 3),
                        blurRadius: 3,
                      )
                    ],
                    color: Colors.greenAccent[400],
                    borderRadius: BorderRadius.circular(10),
                    //  border: Border.all(color: Colors.greenAccent[700], width: 1),
                  ),
                  width: Dimensions.getConvertedWidthSize(context, 160),
                  height: Dimensions.getConvertedHeightSize(context, 50),
                  alignment: Alignment.center,
                  child: Text(
                    Strings.new_patient_done,
                    style: TextStyle(fontSize: 18, color: Colors.teal[900]),
                  ),
                ),*/
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
            ],
          ),
        ));
  }
}

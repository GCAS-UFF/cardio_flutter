import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: Dimensions.getConvertedHeightSize(context, 15),
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
                title: Strings.register,
              ),
              CustomTextFormField(
                hintText: "",
                title: Strings.specialty,
              ),
              CustomTextFormField(
                hintText: Strings.email_hint,
                title: Strings.email_title,
              ),
              CustomTextFormField(
                hintText: Strings.password_hint,
                title: Strings.password_title,
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                onTap: () {
                  Navigator.pushNamed(context, "/");
                },
                title: Strings.sign_up_done,
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
            ],
          ),
        ));
  }
}

import 'package:cardio_flutter/core/widgets/dialog_widget.dart';
import 'package:cardio_flutter/core/widgets/form_cardio.dart';
import 'package:cardio_flutter/core/input_validators/email_input_validator.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

import '../../../../resources/strings.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  static const String LABEL_EMAIL = "LABEL_EMAIL";
  static const String LABEL_PASSWORD = "LABEL_PASSWORD";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = Map<String, dynamic>();
  TextEditingController _emailController;

  @override
  initState() {
    _emailController = TextEditingController(text: _formData[LABEL_EMAIL]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffc9fffd),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              height: Dimensions.getConvertedHeightSize(context, 592),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Color(0xffc9fffd), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: Dimensions.getConvertedHeightSize(context, 30),
                  ),
                  Container(
                    height: Dimensions.getConvertedHeightSize(context, 100),
                    width: Dimensions.getConvertedWidthSize(context, 300),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      Strings.app_name,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: Dimensions.getTextSize(context, 30),
                      ),
                    ),
                  ),
                  Image.asset(
                    Images.app_logo,
                    scale: 4,
                  ),
                  FormCardio(
                    formKey: _formKey,
                    buttonTitle: Strings.login_button,
                    submitForm: () {},
                    formItems: <Widget>[
                      CustomTextFormField(
                        textEditingController: _emailController,
                        hintText: Strings.email_hint,
                        title: Strings.email_title,
                        isRequired: true,
                        validator: EmailInputValidator(),
                        onChanged: (value) {
                          _formData[LABEL_EMAIL] = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomTextFormField(
                        hintText: Strings.password_hint,
                        title: Strings.password_title,
                        isRequired: true,
                        obscureText: true,
                        onChanged: (value) {
                          _formData[LABEL_PASSWORD] = value;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.getConvertedHeightSize(context, 10),
                  ),
                  FlatButton(
                    child: Text(
                      Strings.sign_up_button,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: Dimensions.getTextSize(context, 15),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DialogWidget(
                            text: Strings.signup_warning,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "/professionalSignUp");
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: Dimensions.getConvertedHeightSize(context, 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

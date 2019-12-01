import 'package:cardio_flutter/core/widgets/custom_form_text.dart';
import 'package:cardio_flutter/core/widgets/form_cardio.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
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
                      buttonTitle: Strings.login_button,
                      submitForm: () {},
                      formItems: <Widget>[
                        CustomFormText(
                          hint: Strings.email_hint,
                          title: Strings.email_title,
                        ),
                        CustomFormText(
                          hint: Strings.password_hint,
                          title: Strings.password_title,
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
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:cardio_flutter/core/widgets/dialog_widget.dart';
import 'package:cardio_flutter/core/input_validators/email_input_validator.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/home_patient_page.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/images.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/widgets/button.dart';
import '../../../../resources/cardio_colors.dart';
import '../../../../resources/cardio_colors.dart';
import '../../../../resources/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/bloc/manage_professional_bloc.dart' as professional;

import '../bloc/auth_bloc.dart';

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

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    BlocProvider.of<AuthBloc>(context).add(
      SignInEvent(
        password: _formData[LABEL_PASSWORD],
        email: (_formData[LABEL_EMAIL] != null ? _formData[LABEL_EMAIL].toString().trim() : _formData[LABEL_EMAIL]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Error) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is LoggedProfessional) {
            BlocProvider.of<professional.ManageProfessionalBloc>(context).add(
              professional.Start(
                professional: state.professional,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/homeProfessionalPage',
              (r) => false,
            );
          } else if (state is LoggedPatient) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePatientPage(
                  patient: state.patient,
                ),
              ),
              (r) => false,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              return Center(
                child: LoadingWidget(
                  Container(),
                  size: Dimensions.getConvertedHeightSize(context, 40),
                  strokeWidth: Dimensions.getConvertedWidthSize(context, 5),
                ),
              );
            } else if (state is InitialAuthState) {
              return Center(
                child: LoadingWidget(
                  Container(),
                  size: Dimensions.getConvertedHeightSize(context, 40),
                  strokeWidth: Dimensions.getConvertedWidthSize(context, 5),
                ),
              );
            } else {
              return _buildScaffold(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: Dimensions.getEdgeInsets(context, top: 96, left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              Images.app_logo,
              height: Dimensions.getConvertedHeightSize(context, 165),
              width: Dimensions.getConvertedWidthSize(context, 233),
            ),
            Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: <Widget>[
                    /// E-mail text field
                    CustomTextFormField(
                      textEditingController: _emailController,
                      hintText: Strings.email_hint,
                      title: Strings.email_title,
                      isRequired: true,
                      validator: EmailInputValidator(),
                      onChanged: (value) {
                        setState(() => _formData[LABEL_EMAIL] = value);
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: Dimensions.getConvertedHeightSize(context, 20),
                    ),

                    /// Password text field
                    CustomTextFormField(
                      hintText: Strings.password_hint,
                      title: Strings.password_title,
                      isRequired: true,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() => _formData[LABEL_PASSWORD] = value);
                      },
                    ),
                    SizedBox(
                      height: Dimensions.getConvertedHeightSize(context, 40),
                    ),

                    /// Submit button
                    Button(
                      title: Strings.login_button,
                      onTap: _submitForm,
                    ),
                    // signUpFlatButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget signUpFlatButton(BuildContext context) {
  return FlatButton(
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
              Navigator.pop(context);
              Navigator.pushNamed(context, "/professionalSignUp");
            },
          );
        },
      );
    },
  );
}

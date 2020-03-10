import 'package:cardio_flutter/core/input_validators/cpf_input_validator.dart';
import 'package:cardio_flutter/core/input_validators/email_input_validator.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfessionalSignUpPage extends StatefulWidget {
  @override
  _ProfessionalSignUpPageState createState() => _ProfessionalSignUpPageState();
}

class _ProfessionalSignUpPageState extends State<ProfessionalSignUpPage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_CPF = "LABEL_CPF";
  static const String LABEL_REGIONAL_REGISTER = "LABEL_REGIONAL_REGISTER";
  static const String LABEL_EXPERTISE = "LABEL_EXPERTISE";
  static const String LABEL_EMAIL = "LABEL_EMAIL";
  static const String LABEL_PASSWORD = "LABEL_PASSWORD";

  Map<String, dynamic> _formData = Map<String, dynamic>();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _cpfController = new MultimaskedTextController(
    maskDefault: null,
    maskSecundary: "xxx.xxx.xxx-xx",
    onlyDigitsDefault: false,
    onlyDigitsSecundary: true,
    changeMask: (String text) {
      return (text != null &&
          text.length >= 1 &&
          int.tryParse(text.substring(0, 1)) != null);
    },
  ).maskedTextFieldController;
  TextEditingController _nameController;
  TextEditingController _regionalRegisterController;
  TextEditingController _expertiseController;
  TextEditingController _emailController;

  @override
  void initState() {
    _nameController = TextEditingController(
      text: _formData[LABEL_NAME],
    );
    _regionalRegisterController = TextEditingController(
      text: _formData[LABEL_REGIONAL_REGISTER],
    );
    _expertiseController = TextEditingController(
      text: _formData[LABEL_EXPERTISE],
    );
    _emailController = TextEditingController(
      text: _formData[LABEL_EMAIL],
    );

    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    BlocProvider.of<AuthBloc>(context).add(
      SignUpProfessionalEvent(
        professional: Professional(
          cpf: _formData[LABEL_CPF],
          email: _formData[LABEL_EMAIL],
          name: _formData[LABEL_NAME],
          expertise: _formData[LABEL_EXPERTISE],
          regionalRecord: _formData[LABEL_REGIONAL_REGISTER],
        ),
        password: _formData[LABEL_PASSWORD],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: Dimensions.getConvertedHeightSize(context, 15),
          ),
          CustomTextFormField(
            textEditingController: _nameController,
            isRequired: true,
            hintText: Strings.name_hint,
            title: Strings.name_title,
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              setState(() {
                _formData[LABEL_NAME] = value;
              });
            },
          ),
          CustomTextFormField(
            textEditingController: _cpfController,
            isRequired: true,
            keyboardType: TextInputType.number,
            validator: CpfInputValidator(),
            hintText: Strings.cpf_hint,
            title: Strings.cpf_title,
            onChanged: (value) {
              setState(() {
                _formData[LABEL_CPF] = value;
              });
            },
          ),
          CustomTextFormField(
            textEditingController: _regionalRegisterController,
            isRequired: true,
            hintText: "",
            title: Strings.register,
            onChanged: (value) {
              setState(() {
                _formData[LABEL_REGIONAL_REGISTER] = value;
              });
            },
          ),
          CustomTextFormField(
            textEditingController: _expertiseController,
            isRequired: true,
            hintText: "",
            title: Strings.specialty,
            onChanged: (value) {
              setState(() {
                _formData[LABEL_EXPERTISE] = value;
              });
            },
          ),
          CustomTextFormField(
            textEditingController: _emailController,
            validator: EmailInputValidator(),
            isRequired: true,
            hintText: Strings.email_hint,
            title: Strings.email_title,
            onChanged: (value) {
              setState(() {
                _formData[LABEL_EMAIL] = value;
              });
            },
          ),
          CustomTextFormField(
            isRequired: true,
            hintText: Strings.password_hint,
            title: Strings.password_title,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _formData[LABEL_PASSWORD] = value;
              });
            },
          ),
          SizedBox(
            height: Dimensions.getConvertedHeightSize(context, 20),
          ),
          Button(
            onTap: () {
              _submitForm();
            },
            title: Strings.sign_up_done,
          ),
          SizedBox(
            height: Dimensions.getConvertedHeightSize(context, 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      signOutButton: false,
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            print(state);
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is SignedUp) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/homePage', (r) => false);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Loading) {
                return LoadingWidget(_buildForm(context));
              } else {
                return _buildForm(context);
              }
            },
          ),
        ),
      ),
    );
  }
}

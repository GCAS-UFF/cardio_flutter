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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/bloc/manage_professional_bloc.dart'
    as professional;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // 1. Adicionado super.key

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  static const String LABEL_EMAIL = "LABEL_EMAIL";
  static const String LABEL_PASSWORD = "LABEL_PASSWORD";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  
  // 2. Marcado como 'late' para inicialização no initState
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: _formData[LABEL_EMAIL]);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // 3. Null check obrigatório no currentState
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState?.save();
    
    BlocProvider.of<AuthBloc>(context).add(
      SignInEvent(
        password: _formData[LABEL_PASSWORD] ?? "",
        email: (_formData[LABEL_EMAIL]?.toString().trim() ?? ""),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Error) {
              // 4. Scaffold.of mudou para ScaffoldMessenger
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is LoggedProfessional) {
              BlocProvider.of<professional.ManageProfessionalBloc>(context)
                  .add(professional.Start(professional: state.professional));
              Navigator.pushNamedAndRemoveUntil(
                  context, '/homeProfessionalPage', (r) => false);
            } else if (state is LoggedPatient) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePatientPage(patient: state.patient)),
                  (r) => false);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Loading) {
                return LoadingWidget(_buildScaffold(context));
              } else if (state is InitialAuthState) {
                return LoadingWidget(const SizedBox());
              } else {
                return _buildScaffold(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Garante altura total
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Color(0xffc9fffd), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: Dimensions.getConvertedHeightSize(context, 30)),
          Container(
            height: Dimensions.getConvertedHeightSize(context, 100),
            width: Dimensions.getConvertedWidthSize(context, 300),
            alignment: Alignment.center,
            child: Text(
              Strings.app_name,
              style: TextStyle(
                color: Colors.indigo,
                fontSize: Dimensions.getTextSize(context, 30),
              ),
            ),
          ),
          Image.asset(Images.app_logo, scale: 4),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
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
                CustomTextFormField(
                  hintText: Strings.password_hint,
                  title: Strings.password_title,
                  isRequired: true,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() => _formData[LABEL_PASSWORD] = value);
                  },
                ),
                Container(
                  margin: Dimensions.getEdgeInsets(context, top: 15),
                  child: Button(
                    title: Strings.login_button,
                    onTap: _submitForm,
                  ),
                ),
              ],
            ),
          ),
          _signUpButton(context),
          SizedBox(height: Dimensions.getConvertedHeightSize(context, 10)),
        ],
      ),
    );
  }

  Widget _signUpButton(BuildContext context) {
    // 5. FlatButton foi substituído por TextButton
    return TextButton(
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
}
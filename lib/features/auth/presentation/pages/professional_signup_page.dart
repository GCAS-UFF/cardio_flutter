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
import 'package:cardio_flutter/features/manage_professional/presentation/bloc/manage_professional_bloc.dart'
    as professional_bloc;

class ProfessionalSignUpPage extends StatefulWidget {
  final Professional? professional; // 1. Opcional para permitir cadastro novo

  const ProfessionalSignUpPage({super.key, this.professional});

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

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Controladores marcados como late e correção do Multimasked
  late final TextEditingController _cpfController;
  late final TextEditingController _nameController;
  late final TextEditingController _regionalRegisterController;
  late final TextEditingController _expertiseController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    // 3. Ajuste no Multimasked: maskDefault não pode ser null e correção de "Secondary"
    _cpfController = MultimaskedTextController(
      maskDefault: "", // Mudar de null para string vazia
      maskSecondary: "xxx.xxx.xxx-xx", // Corrigido de "Secundary"
      onlyDigitsDefault: false,
      onlyDigitsSecondary: true, // Corrigido de "Secundary"
      changeMask: (String? text) { // Aceitar String nula
        return (text != null &&
            text.isNotEmpty &&
            int.tryParse(text.substring(0, 1)) != null);
      },
    ).maskedTextFieldController;

    if (widget.professional != null) {
      final prof = widget.professional!;
      _formData[LABEL_NAME] = prof.name;
      _formData[LABEL_CPF] = prof.cpf;
      _formData[LABEL_REGIONAL_REGISTER] = prof.regionalRecord;
      _formData[LABEL_EXPERTISE] = prof.expertise;
      _formData[LABEL_EMAIL] = prof.email;
      _cpfController.text = prof.cpf;
    }

    _nameController = TextEditingController(text: _formData[LABEL_NAME]);
    _regionalRegisterController = TextEditingController(text: _formData[LABEL_REGIONAL_REGISTER]);
    _expertiseController = TextEditingController(text: _formData[LABEL_EXPERTISE]);
    _emailController = TextEditingController(text: _formData[LABEL_EMAIL]);
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nameController.dispose();
    _regionalRegisterController.dispose();
    _expertiseController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // 4. Null check no currentState
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState?.save();

    BlocProvider.of<AuthBloc>(context).add(
      SignUpProfessionalEvent(
        professional: Professional(
          cpf: _formData[LABEL_CPF] ?? "",
          email: _formData[LABEL_EMAIL] ?? "",
          name: _formData[LABEL_NAME] ?? "",
          expertise: _formData[LABEL_EXPERTISE] ?? "",
          regionalRecord: _formData[LABEL_REGIONAL_REGISTER] ?? "",
        ),
        password: _formData[LABEL_PASSWORD] ?? "",
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return BasePage(
        signOutButton: false,
        backgroundColor: const Color(0xffc9fffd),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: Dimensions.getConvertedHeightSize(context, 15)),
                CustomTextFormField(
                  textEditingController: _nameController,
                  isRequired: true,
                  hintText: Strings.name_hint,
                  title: Strings.name_title,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) => setState(() => _formData[LABEL_NAME] = value),
                ),
                CustomTextFormField(
                  textEditingController: _cpfController,
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  validator: CpfInputValidator(),
                  hintText: Strings.cpf_hint,
                  title: Strings.cpf_title,
                  onChanged: (value) => setState(() => _formData[LABEL_CPF] = value),
                ),
                CustomTextFormField(
                  textEditingController: _regionalRegisterController,
                  isRequired: true,
                  hintText: "",
                  title: Strings.register,
                  onChanged: (value) => setState(() => _formData[LABEL_REGIONAL_REGISTER] = value),
                ),
                CustomTextFormField(
                  textEditingController: _expertiseController,
                  isRequired: true,
                  hintText: "",
                  title: Strings.specialty,
                  onChanged: (value) => setState(() => _formData[LABEL_EXPERTISE] = value),
                ),
                CustomTextFormField(
                  textEditingController: _emailController,
                  validator: EmailInputValidator(),
                  isRequired: true,
                  hintText: Strings.email_hint,
                  title: Strings.email_title,
                  onChanged: (value) => setState(() => _formData[LABEL_EMAIL] = value),
                ),
                if (widget.professional == null)
                  CustomTextFormField(
                    isRequired: true,
                    hintText: Strings.password_hint,
                    title: Strings.password_title,
                    obscureText: true,
                    onChanged: (value) => setState(() => _formData[LABEL_PASSWORD] = value),
                  ),
                SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
                Button(
                  onTap: _submitForm,
                  title: (widget.professional == null)
                      ? Strings.sign_up_done
                      : Strings.edit_patient_done,
                ),
                SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Error) {
          // 5. Substituído Flushbar por ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is SignedUp) {
          BlocProvider.of<professional_bloc.ManageProfessionalBloc>(context)
              .add(professional_bloc.Start(professional: state.user));
          Navigator.pop(context);
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
    );
  }
}
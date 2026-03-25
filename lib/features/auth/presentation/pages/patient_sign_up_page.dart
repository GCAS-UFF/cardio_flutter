import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/bloc/manage_professional_bloc.dart'
    as professional;
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/input_validators/cpf_input_validator.dart';
import '../../../../core/input_validators/date_input_validator.dart';
import '../../../../core/utils/multimasked_text_controller.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/patient.dart';
import '../bloc/auth_bloc.dart';

class PatientSignUpPage extends StatefulWidget {
  final Patient? patient; // 1. Opcional para criação, preenchido para edição

  const PatientSignUpPage({super.key, this.patient});

  @override
  _PatientSignUpPageState createState() => _PatientSignUpPageState();
}

class _PatientSignUpPageState extends State<PatientSignUpPage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_CPF = "LABEL_CPF";
  static const String LABEL_ADDRESS = "LABEL_ADDRESS"; // 2. Corrigido spelling
  static const String LABEL_BIRTHDATE = "LABEL_BIRTHDATE";
  static const String LABEL_EMAIL = "LABEL_EMAIL";

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 3. Controllers marcados como late para inicialização no initState
  late final TextEditingController _cpfController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    _cpfController = MultimaskedTextController(
      maskDefault: "xxx.xxx.xxx-xx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    _birthDateController = MultimaskedTextController(
      maskDefault: "xx/xx/xxxx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    if (widget.patient != null) {
      final p = widget.patient!;
      _formData[LABEL_NAME] = p.name;
      _formData[LABEL_ADDRESS] = p.address;
      _formData[LABEL_EMAIL] = p.email;
      _formData[LABEL_BIRTHDATE] = DateHelper.convertDateToString(p.birthdate);
      _formData[LABEL_CPF] = Converter.convertStringToMaskedString(
          value: p.cpf, mask: "xxx.xxx.xxx-xx");
      
      _cpfController.text = _formData[LABEL_CPF];
      _birthDateController.text = _formData[LABEL_BIRTHDATE];
    }

    _nameController = TextEditingController(text: _formData[LABEL_NAME]);
    _addressController = TextEditingController(text: _formData[LABEL_ADDRESS]);
    _emailController = TextEditingController(text: _formData[LABEL_EMAIL]);

    super.initState();
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _birthDateController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // 4. Null check no currentState
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState?.save();

    // 5. Garantia de data válida para o construtor do Patient
    final birthDate = DateHelper.convertStringToDate(_formData[LABEL_BIRTHDATE]);
    if (birthDate == null) return;

    if (widget.patient == null) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpPatientEvent(
          patient: Patient(
            cpf: _formData[LABEL_CPF],
            email: _formData[LABEL_EMAIL],
            name: _formData[LABEL_NAME],
            address: _formData[LABEL_ADDRESS],
            birthdate: birthDate,
          ),
        ),
      );
    } else {
      BlocProvider.of<professional.ManageProfessionalBloc>(context).add(
        professional.EditPatientEvent(
          patient: Patient(
            id: widget.patient!.id,
            cpf: _formData[LABEL_CPF],
            email: _formData[LABEL_EMAIL],
            name: _formData[LABEL_NAME],
            address: _formData[LABEL_ADDRESS],
            birthdate: birthDate,
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is SignedUp) {
              BlocProvider.of<professional.ManageProfessionalBloc>(context)
                  .add(professional.Refresh());
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
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 10)),
            CustomTextFormField(
              textCapitalization: TextCapitalization.words,
              isRequired: true,
              textEditingController: _nameController,
              hintText: Strings.name_hint,
              title: Strings.name_title,
              onChanged: (value) => setState(() => _formData[LABEL_NAME] = value),
            ),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              validator: CpfInputValidator(),
              textEditingController: _cpfController,
              hintText: Strings.cpf_hint,
              title: Strings.cpf_title,
              onChanged: (value) => setState(() => _formData[LABEL_CPF] = value),
            ),
            CustomTextFormField(
              isRequired: true,
              textEditingController: _addressController,
              hintText: "",
              title: Strings.adress,
              onChanged: (value) => setState(() => _formData[LABEL_ADDRESS] = value),
            ),
            CustomTextFormField(
              isRequired: true,
              textEditingController: _birthDateController,
              hintText: Strings.date,
              title: Strings.birth,
              validator: DateInputValidator(),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() => _formData[LABEL_BIRTHDATE] = value),
            ),
            CustomTextFormField(
              isRequired: true,
              textEditingController: _emailController,
              hintText: Strings.email_hint,
              enable: widget.patient == null,
              title: Strings.email_title,
              onChanged: (value) => setState(() => _formData[LABEL_EMAIL] = value),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
            Button(
              title: (widget.patient == null)
                  ? Strings.new_patient_done
                  : Strings.edit_patient_done,
              onTap: _submitForm,
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
          ],
        ));
  }
}
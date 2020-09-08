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
  final Patient patient;

  PatientSignUpPage({this.patient});

  @override
  _PatientSignUpPageState createState() => _PatientSignUpPageState();
}

class _PatientSignUpPageState extends State<PatientSignUpPage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_CPF = "LABEL_CPF";
  static const String LABEL_ADRESS = "LABEL_ADRESS";
  static const String LABEL_BIRTHDATE = "LABEL_BIRTHDATE";
  static const String LABEL_EMAIL = "LABEL_EMAIL";
  static const String LABEL_PASSWORD = "LABEL_PASSWORD";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _cpfController = new MultimaskedTextController(
    maskDefault: "xxx.xxx.xxx-xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  final TextEditingController _birthDateController =
      new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _nameController;
  TextEditingController _adressController;
  TextEditingController _emailController;

  @override
  void initState() {
    if (widget.patient != null) {
      _formData[LABEL_NAME] = widget.patient.name;
      _formData[LABEL_ADRESS] = widget.patient.address;
      _formData[LABEL_EMAIL] = widget.patient.email;
      _formData[LABEL_BIRTHDATE] =
          DateHelper.convertDateToString(widget.patient.birthdate);
      _formData[LABEL_CPF] = Converter.convertStringToMaskedString(
          value: widget.patient.cpf, mask: "xxx.xxx.xxx-xx");
      _cpfController.text = _formData[LABEL_CPF];
      _birthDateController.text = _formData[LABEL_BIRTHDATE];
    }
    _nameController = TextEditingController(
      text: _formData[LABEL_NAME],
    );
    _adressController = TextEditingController(
      text: _formData[LABEL_ADRESS],
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
    if (widget.patient == null) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpPatientEvent(
          patient: Patient(
            cpf: _formData[LABEL_CPF],
            email: _formData[LABEL_EMAIL],
            name: _formData[LABEL_NAME],
            address: _formData[LABEL_ADRESS],
            birthdate: DateHelper.convertStringToDate(
              _formData[LABEL_BIRTHDATE],
            ),
          ),
        ),
      );
    } else {
      BlocProvider.of<professional.ManageProfessionalBloc>(context).add(
        professional.EditPatientEvent(
          patient: Patient(
            id: widget.patient.id,
            cpf: _formData[LABEL_CPF],
            email: _formData[LABEL_EMAIL],
            name: _formData[LABEL_NAME],
            address: _formData[LABEL_ADRESS],
            birthdate: DateHelper.convertStringToDate(
              _formData[LABEL_BIRTHDATE],
            ),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: Dimensions.getConvertedHeightSize(context, 10),
            ),
            CustomTextFormField(
              textCapitalization: TextCapitalization.words,
              isRequired: true,
              textEditingController: _nameController,
              hintText: Strings.name_hint,
              title: Strings.name_title,
              onChanged: (value) {
                setState(() {
                  _formData[LABEL_NAME] = value;
                });
              },
            ),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              validator: CpfInputValidator(),
              textEditingController: _cpfController,
              hintText: Strings.cpf_hint,
              title: Strings.cpf_title,
              onChanged: (value) {
                setState(() {
                  _formData[LABEL_CPF] = value;
                });
              },
            ),
            CustomTextFormField(
              isRequired: true,
              textEditingController: _adressController,
              hintText: "",
              title: Strings.adress,
              onChanged: (value) {
                setState(() {
                  _formData[LABEL_ADRESS] = value;
                });
              },
            ),
            CustomTextFormField(
              isRequired: true,
              textEditingController: _birthDateController,
              hintText: Strings.date,
              title: Strings.birth,
              validator: DateInputValidator(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _formData[LABEL_BIRTHDATE] = value.toString();
                });
              },
            ),
            CustomTextFormField(
              isRequired: true,
              textEditingController: _emailController,
              hintText: Strings.email_hint,
              enable: widget.patient == null,
              title: Strings.email_title,
              onChanged: (value) {
                setState(() {
                  _formData[LABEL_EMAIL] = value;
                });
              },
            ),
            SizedBox(
              height: Dimensions.getConvertedHeightSize(context, 20),
            ),
            Button(
              title: (widget.patient == null)
                  ? Strings.new_patient_done
                  : Strings.edit_patient_done,
              onTap: () {
                _submitForm();
              },
            ),
            SizedBox(
              height: Dimensions.getConvertedHeightSize(context, 20),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
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
}

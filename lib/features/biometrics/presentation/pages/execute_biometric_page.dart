import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class ExecuteBiometricPage extends StatefulWidget {
  final Biometric biometric;

  ExecuteBiometricPage({this.biometric});

  @override
  State<StatefulWidget> createState() {
    return _ExecuteBiometricPageState();
  }
}

class _ExecuteBiometricPageState extends State<ExecuteBiometricPage> {
  static const String LABEL_FREQUENCY = "LABEL_FREQUENCY";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";
  static const String LABEL_WEIGHT = "LABEL_WEIGHT";
  static const String LABEL_BPM = "LABEL_BPM";
  static const String LABEL_BLOOD_PRESSURE = "LABEL_BLOOD_PRESSURE";
  static const String LABEL_SWELLING = "LABEL_SWELLING";
  static const String LABEL_FATIGUE = "LABEL_FATIGUE";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _weightController = new MultimaskedTextController(
    maskDefault: "xxx.x",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _bpmController;
  TextEditingController _bloodPressureController;
  TextEditingController _swellingController;
  TextEditingController _fatigueController;

  @override
  void initState() {
    if (widget.biometric != null) {}

    _weightController = TextEditingController(
      text: _formData[LABEL_WEIGHT],
    );
    _bpmController = TextEditingController(
      text: _formData[LABEL_BPM],
    );
    _bloodPressureController = TextEditingController(
      text: _formData[LABEL_BLOOD_PRESSURE],
    );
    _swellingController = TextEditingController(
      text: _formData[LABEL_SWELLING],
    );
    _fatigueController = TextEditingController(
      text: _formData[LABEL_FATIGUE],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(child: _buildForm(context)),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 10),
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _weightController,
                hintText: Strings.weight_hint,
                title: Strings.weight_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_WEIGHT] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _bpmController,
                hintText: Strings.bpm_hint,
                title: Strings.bpm_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_BPM] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _bloodPressureController,
                hintText: Strings.blood_pressure_hint,
                title: Strings.blood_pressure_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_BLOOD_PRESSURE] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _swellingController,
                hintText: "",
                title: Strings.swelling,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_SWELLING] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _fatigueController,
                hintText: '',
                title: Strings.fatigue,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_FATIGUE] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: (widget.biometric == null)
                    ? Strings.add
                    : Strings.edit_patient_done,
                onTap: () {
                  _submitForm();
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
            ],
          ),
        ));
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
  }
}

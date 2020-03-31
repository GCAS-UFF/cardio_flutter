import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';

import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class ExecuteMedicationPage extends StatefulWidget {
  final Medication medication;

  ExecuteMedicationPage({this.medication});

  @override
  State<StatefulWidget> createState() {
    return _ExecuteMedicationPageState();
  }
}

class _ExecuteMedicationPageState extends State<ExecuteMedicationPage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_DOSAGE = "LABEL_DOSAGE";
  static const String LABEL_QUANTITY = "LABEL_QUANTITY";
  static const String LABEL_FREQUENCY = "LABEL_FREQUENCY";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";
  static const String LABEL_INITIAL_TIME = "LABEL_INITIAL_TIME";
  static const String LABEL_OBSERVATION = "LABEL_OBSERVATION";
  static const String LABEL_EXECUTION_DAY = "LABEL_EXECUTION_DAY";
  static const String LABEL_EXECUTION_TIME = "LABEL_EXECUTION_TIME";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _dosageController;
  TextEditingController _quantityController;
  TextEditingController _executionDayController = new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _executionTimeController = new MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _observationController;

  @override
  void initState() {
    if (widget.medication != null) {
      _formData[LABEL_EXECUTION_DAY] =
          DateHelper.convertDateToString(DateTime.now());
      _formData[LABEL_NAME] = widget.medication.name;
      _formData[LABEL_DOSAGE] = widget.medication.dosage;
      _formData[LABEL_QUANTITY] = widget.medication.quantity;
      _formData[LABEL_OBSERVATION] = widget.medication.observation;
    }

    
      
    _nameController = TextEditingController(
      text: _formData[LABEL_NAME],
    );
  
    _dosageController = TextEditingController(
      text: _formData[LABEL_DOSAGE],
    );
    _quantityController = TextEditingController(
      text: _formData[LABEL_QUANTITY],
    );
    _observationController = TextEditingController(
      text: _formData[LABEL_OBSERVATION],
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
                textEditingController: _nameController,
                hintText: "",
                enable: false,
                title: Strings.medication_name,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_NAME] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                enable: false,
                textEditingController: _dosageController,
                hintText: "",
                title: Strings.dosage,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_DOSAGE] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                enable: false,
                textEditingController: _quantityController,
                hintText: "",
                title: Strings.quantity,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_QUANTITY] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _executionDayController,
                enable: false,
                hintText: "",
                validator: DateInputValidator(),
                title: Strings.initial_date,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_EXECUTION_DAY] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _executionTimeController,
                hintText: "",
                title: Strings.time_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_EXECUTION_TIME] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                
                textEditingController: _observationController,
                hintText: "",
                title: Strings.observation,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_OBSERVATION] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: (widget.medication == null)
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

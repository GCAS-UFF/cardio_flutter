import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/input_validators/time_of_day_validator.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_radio_list_form_text_field.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';

import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  static const String LABEL_EXECUTED_DATE = "LABEL_EXECUTED_DATE";
  static const String LABEL_EXECUTION_TIME = "LABEL_EXECUTION_TIME";
  static const String LABEL_OBSERVATION = "LABEL_OBSERVATION";
  static const String LABEL_TOOK_IT = "LABEL_TOOK_IT";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _dosageController;
  TextEditingController _quantityController;
  TextEditingController _executedDateController = new MultimaskedTextController(
    maskDefault: "##/##/####",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _executionTimeController = new MultimaskedTextController(
    maskDefault: "##:##",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _observationController;

  @override
  void initState() {
    if (widget.medication != null) {
      _formData[LABEL_NAME] = widget.medication.name;
      _formData[LABEL_DOSAGE] = (widget.medication.dosage == null) ? null : widget.medication.dosage.toString();
      _formData[LABEL_QUANTITY] = (widget.medication.quantity == null) ? null : widget.medication.quantity.toString();
      _formData[LABEL_EXECUTED_DATE] =
          (!widget.medication.done) ? DateHelper.convertDateToString(DateTime.now()) : DateHelper.convertDateToString(widget.medication.executedDate);
      _formData[LABEL_EXECUTION_TIME] = DateHelper.getTimeFromDate(widget.medication.executedDate);
      _formData[LABEL_OBSERVATION] = (!widget.medication.done) ? null : widget.medication.observation;
      _formData[LABEL_TOOK_IT] = widget.medication.tookIt != null && widget.medication.tookIt ? YesNoRadioOptions.YES : YesNoRadioOptions.NO;
      _executedDateController.text = _formData[LABEL_EXECUTED_DATE];
      _executionTimeController.text = _formData[LABEL_EXECUTION_TIME];
    }

    _formData[LABEL_TOOK_IT] = widget.medication.tookIt != null && widget.medication.tookIt ? YesNoRadioOptions.YES : YesNoRadioOptions.NO;

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
      recomendation: Strings.medication,
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Medication>, GenericState<Medication>>(
          listener: (context, state) {
            if (state is Error<Medication>) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is Loaded<Medication>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Medication>, GenericState<Medication>>(
            builder: (context, state) {
              print(state);
              if (state is Loading<Medication>) {
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
    return Container(
      padding: Dimensions.getEdgeInsets(context, top: 10, left: 30, right: 30, bottom: 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
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
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
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
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomTextFormField(
                isRequired: true,
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
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _executedDateController,
                enable: true,
                hintText: Strings.date,
                validator: DateInputValidator(),
                title: Strings.executed_date,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_EXECUTED_DATE] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _executionTimeController,
                hintText: Strings.time_hint,
                validator: TimeofDayValidator(),
                title: Strings.time_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_EXECUTION_TIME] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomTextFormField(
                textEditingController: _observationController,
                hintText: Strings.observation_hint,
                title: Strings.observation,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_OBSERVATION] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getTextSize(context, 20),
              ),
              CustomRadioListFormField(
                title: Strings.tookIt,
                groupValue: _formData[LABEL_TOOK_IT],
                onChanged: (tookit) {
                  setState(() {
                    _formData[LABEL_TOOK_IT] = tookit;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: (!widget.medication.done) ? Strings.add : Strings.edit_patient_done,
                onTap: () {
                  _submitForm();
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    if (!widget.medication.done) {
      BlocProvider.of<GenericBloc<Medication>>(context).add(
        ExecuteEvent<Medication>(
          entity: Medication(
            done: true,
            name: _formData[LABEL_NAME],
            dosage: double.parse(_formData[LABEL_DOSAGE]),
            quantity: _formData[LABEL_QUANTITY],
            executedDate: DateHelper.addTimeToDate(
              _formData[LABEL_EXECUTION_TIME],
              DateHelper.convertStringToDate(_formData[LABEL_EXECUTED_DATE]),
            ),
            observation: _formData[LABEL_OBSERVATION],
            tookIt: _formData[LABEL_TOOK_IT] == YesNoRadioOptions.YES ? true : false,
          ),
        ),
      );
    } else {
      BlocProvider.of<GenericBloc<Medication>>(context).add(
        EditExecutedEvent<Medication>(
          entity: Medication(
            id: widget.medication.id,
            done: true,
            name: _formData[LABEL_NAME],
            dosage: double.parse(_formData[LABEL_DOSAGE]),
            quantity: _formData[LABEL_QUANTITY],
            executedDate: DateHelper.addTimeToDate(
              _formData[LABEL_EXECUTION_TIME],
              DateHelper.convertStringToDate(_formData[LABEL_EXECUTED_DATE]),
            ),
            observation: _formData[LABEL_OBSERVATION],
            tookIt: _formData[LABEL_TOOK_IT] == YesNoRadioOptions.YES ? true : false,
          ),
        ),
      );
    }
  }
}

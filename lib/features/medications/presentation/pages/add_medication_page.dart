import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/input_validators/time_of_day_validator.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';

import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/features/medications/domain/entities/medication.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMedicationPage extends StatefulWidget {
  final Medication medication;

  AddMedicationPage({this.medication});

  @override
  State<StatefulWidget> createState() {
    return _AddMedicationPageState();
  }
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_DOSAGE = "LABEL_DOSAGE";
  static const String LABEL_QUANTITY = "LABEL_QUANTITY";
  static const String LABEL_FREQUENCY = "LABEL_FREQUENCY";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";
  static const String LABEL_INITIAL_TIME = "LABEL_INITIAL_TIME";
  static const String LABEL_OBSERVATION = "LABEL_OBSERVATION";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _dosageController;
  TextEditingController _quantityController;
  TextEditingController _frequencyController;
  final TextEditingController _initialdateController =
      new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  final TextEditingController _finalDateController =
      new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  final TextEditingController _initialTimeController =
      new MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  TextEditingController _observationController;

  @override
  void initState() {
    if (widget.medication != null) {
      _formData[LABEL_FREQUENCY] = (widget.medication.frequency == null)
          ? null
          : widget.medication.frequency.toString();
      _formData[LABEL_INITIAL_DATE] =
          DateHelper.convertDateToString(widget.medication.initialDate);
      _formData[LABEL_FINAL_DATE] =
          DateHelper.convertDateToString(widget.medication.finalDate);
      _formData[LABEL_INITIAL_TIME] =
          DateHelper.getTimeFromDate(widget.medication.initialDate);
      _formData[LABEL_NAME] = widget.medication.name;
      _formData[LABEL_DOSAGE] = (widget.medication.dosage == null)
          ? null
          : widget.medication.dosage.toString();
      _formData[LABEL_QUANTITY] = (widget.medication.quantity == null)
          ? null
          : widget.medication.quantity.toString();
      _formData[LABEL_OBSERVATION] = widget.medication.observation;

      _initialdateController.text = _formData[LABEL_INITIAL_DATE];
      _finalDateController.text = _formData[LABEL_FINAL_DATE];
      _initialTimeController.text = _formData[LABEL_INITIAL_TIME];
    }

    _frequencyController = TextEditingController(
      text: _formData[LABEL_FREQUENCY],
    );

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
                hintText: Strings.medication_hint,
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
                textEditingController: _dosageController,
                hintText: Strings.dosage_hint,
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
                textEditingController: _initialdateController,
                hintText: Strings.date,
                validator: DateInputValidator(),
                title: Strings.initial_date,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_INITIAL_DATE] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _initialTimeController,
                hintText: Strings.time_hint,
                title: Strings.initial_time,
                validator: TimeofDayValidator(),
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_INITIAL_TIME] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _frequencyController,
                hintText: Strings.hint_frequency,
                title: Strings.frequency,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_FREQUENCY] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _finalDateController,
                hintText: Strings.date,
                title: Strings.final_date,
                validator: DateInputValidator(),
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_FINAL_DATE] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
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

    if (widget.medication == null) {
      BlocProvider.of<GenericBloc<Medication>>(context).add(
        AddRecomendationEvent<Medication>(
          entity: Medication(
            done: false,
            name: _formData[LABEL_NAME],
            dosage: (_formData[LABEL_DOSAGE] is int)
                ? int.parse(_formData[LABEL_DOSAGE]).toDouble()
                : double.parse(_formData[LABEL_DOSAGE]),
            quantity: int.parse(_formData[LABEL_QUANTITY]),
            frequency: int.parse(_formData[LABEL_FREQUENCY]),
            initialDate: DateHelper.addTimeToDate(
              _formData[LABEL_INITIAL_TIME],
              DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
            ),
            finalDate: DateHelper.addTimeToDate(
              _formData[LABEL_INITIAL_TIME],
              DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]),
            ),
            observation: _formData[LABEL_OBSERVATION],
          ),
        ),
      );
    } else {
      BlocProvider.of<GenericBloc<Medication>>(context).add(
        EditRecomendationEvent<Medication>(
          entity: Medication(
            id: widget.medication.id,
            done: false,
            name: _formData[LABEL_NAME],
            dosage: (_formData[LABEL_DOSAGE] is int)
                ? int.parse(_formData[LABEL_DOSAGE]).toDouble()
                : double.parse(_formData[LABEL_DOSAGE]),
            quantity: int.parse(_formData[LABEL_QUANTITY]),
            frequency: int.parse(_formData[LABEL_FREQUENCY]),
            initialDate: DateHelper.addTimeToDate(
              _formData[LABEL_INITIAL_TIME],
              DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
            ),
            finalDate: DateHelper.addTimeToDate(
              _formData[LABEL_INITIAL_TIME],
              DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]),
            ),
            observation: _formData[LABEL_OBSERVATION],
          ),
        ),
      );
    }
  }
}

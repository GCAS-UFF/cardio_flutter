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

class ExecuteMedicationPage extends StatefulWidget {
  final Medication medication;

  const ExecuteMedicationPage({super.key, required this.medication});

  @override
  State<StatefulWidget> createState() => _ExecuteMedicationPageState();
}

class _ExecuteMedicationPageState extends State<ExecuteMedicationPage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_DOSAGE = "LABEL_DOSAGE";
  static const String LABEL_QUANTITY = "LABEL_QUANTITY";
  static const String LABEL_EXECUTED_DATE = "LABEL_EXECUTED_DATE";
  static const String LABEL_EXECUTION_TIME = "LABEL_EXECUTION_TIME";
  static const String LABEL_OBSERVATION = "LABEL_OBSERVATION";
  static const String LABEL_TOOK_IT = "LABEL_TOOK_IT";

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _quantityController;
  late TextEditingController _executedDateController;
  late TextEditingController _executionTimeController;
  late TextEditingController _observationController;

  @override
  void initState() {
    super.initState();

    _formData[LABEL_NAME] = widget.medication.name;
    _formData[LABEL_DOSAGE] = widget.medication.dosage?.toString();
    _formData[LABEL_QUANTITY] = widget.medication.quantity;
    _formData[LABEL_EXECUTED_DATE] = (!widget.medication.done)
        ? DateHelper.convertDateToString(DateTime.now())
        : DateHelper.convertDateToString(widget.medication.executedDate);
    _formData[LABEL_EXECUTION_TIME] = DateHelper.getTimeFromDate(widget.medication.executedDate);
    _formData[LABEL_OBSERVATION] = widget.medication.observation;
    _formData[LABEL_TOOK_IT] = widget.medication.tookIt ?? false;

    _executedDateController = MultimaskedTextController(
      maskDefault: "xx/xx/xxxx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;
    _executedDateController.text = _formData[LABEL_EXECUTED_DATE] ?? "";

    _executionTimeController = MultimaskedTextController(
      maskDefault: "xx:xx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;
    _executionTimeController.text = _formData[LABEL_EXECUTION_TIME] ?? "";

    _nameController = TextEditingController(text: _formData[LABEL_NAME]);
    _dosageController = TextEditingController(text: _formData[LABEL_DOSAGE]);
    _quantityController = TextEditingController(text: _formData[LABEL_QUANTITY]);
    _observationController = TextEditingController(text: _formData[LABEL_OBSERVATION]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _quantityController.dispose();
    _executedDateController.dispose();
    _executionTimeController.dispose();
    _observationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Medication>, GenericState<Medication>>(
          listener: (context, state) {
            if (state is Error<Medication>) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is Loaded<Medication>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Medication>, GenericState<Medication>>(
            builder: (context, state) {
              return state is Loading<Medication>
                  ? LoadingWidget(_buildForm(context))
                  : _buildForm(context);
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
            isRequired: true,
            textEditingController: _nameController,
            enable: false,
            hintText: "", // Adicionado hintText
            title: Strings.medication_name,
            onChanged: (value) => setState(() => _formData[LABEL_NAME] = value),
          ),
          CustomTextFormField(
            isRequired: true,
            enable: false,
            textEditingController: _dosageController,
            hintText: "", // Adicionado hintText
            title: Strings.dosage,
            onChanged: (value) => setState(() => _formData[LABEL_DOSAGE] = value),
          ),
          CustomTextFormField(
            isRequired: true,
            enable: false,
            textEditingController: _quantityController,
            hintText: "", // Adicionado hintText
            title: Strings.quantity,
            onChanged: (value) => setState(() => _formData[LABEL_QUANTITY] = value),
          ),
          CustomTextFormField(
            isRequired: true,
            keyboardType: TextInputType.number,
            textEditingController: _executedDateController,
            hintText: Strings.date, // Adicionado hintText
            validator: DateInputValidator(),
            title: Strings.executed_date,
            onChanged: (value) => setState(() => _formData[LABEL_EXECUTED_DATE] = value),
          ),
          CustomTextFormField(
            isRequired: true,
            keyboardType: TextInputType.number,
            textEditingController: _executionTimeController,
            hintText: Strings.time_hint,
            validator: TimeOfDayValidator(), // Corrigido de TimeofDay para TimeOfDay
            title: Strings.time_title,
            onChanged: (value) => setState(() => _formData[LABEL_EXECUTION_TIME] = value),
          ),
          CustomTextFormField(
            textEditingController: _observationController,
            hintText: Strings.observation_hint,
            title: Strings.observation,
            onChanged: (value) => setState(() => _formData[LABEL_OBSERVATION] = value),
          ),
          SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
          
          // Seção "Tomou o remédio?"
          _buildTookItRadioSection(),

          SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
          Button(
            title: (!widget.medication.done) ? Strings.add : Strings.edit_patient_done,
            onTap: _submitForm,
          ),
          SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
        ],
      ),
    );
  }

  Widget _buildTookItRadioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Dimensions.getEdgeInsets(context, left: 25),
          child: Text(
            Strings.tookIt,
            style: TextStyle(fontSize: Dimensions.getTextSize(context, 15)),
          ),
        ),
        // Para evitar depreciação de v3.32+, usamos ListTile que é o padrão atual
        RadioListTile<bool>(
          title: const Text('Sim'),
          value: true,
          groupValue: _formData[LABEL_TOOK_IT],
          activeColor: Colors.teal,
          onChanged: (bool? value) {
            setState(() => _formData[LABEL_TOOK_IT] = value);
          },
        ),
        RadioListTile<bool>(
          title: const Text('Não'),
          value: false,
          groupValue: _formData[LABEL_TOOK_IT],
          activeColor: Colors.teal,
          onChanged: (bool? value) {
            setState(() => _formData[LABEL_TOOK_IT] = value);
          },
        ),
      ],
    );
  }

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();

    final medicationData = Medication(
      id: widget.medication.id,
      done: true,
      name: _formData[LABEL_NAME] ?? "",
      dosage: double.tryParse(_formData[LABEL_DOSAGE]?.toString() ?? "0") ?? 0.0,
      quantity: _formData[LABEL_QUANTITY] ?? "",
      executedDate: DateHelper.addTimeToDate(
        _formData[LABEL_EXECUTION_TIME],
        DateHelper.convertStringToDate(_formData[LABEL_EXECUTED_DATE]),
      ),
      observation: _formData[LABEL_OBSERVATION] ?? "",
      tookIt: _formData[LABEL_TOOK_IT],
      initialDate: widget.medication.initialDate,
      finalDate: widget.medication.finalDate,
    );

    if (!widget.medication.done) {
      BlocProvider.of<GenericBloc<Medication>>(context).add(
        ExecuteEvent<Medication>(entity: medicationData),
      );
    } else {
      BlocProvider.of<GenericBloc<Medication>>(context).add(
        EditExecutedEvent<Medication>(entity: medicationData),
      );
    }
  }
}
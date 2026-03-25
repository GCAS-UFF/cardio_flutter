import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/core/widgets/custom_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExecuteBiometricPage extends StatefulWidget {
  final Biometric biometric;

  const ExecuteBiometricPage({super.key, required this.biometric});

  @override
  State<StatefulWidget> createState() => _ExecuteBiometricPageState();
}

class _ExecuteBiometricPageState extends State<ExecuteBiometricPage> {
  static const String LABEL_WEIGHT = "LABEL_WEIGHT";
  static const String LABEL_BPM = "LABEL_BPM";
  static const String LABEL_BLOOD_PRESSURE = "LABEL_BLOOD_PRESSURE";
  static const String LABEL_SWELLING = "LABEL_SWELLING";
  static const String LABEL_FATIGUE = "LABEL_FATIGUE";
  static const String LABEL_TIME = "LABEL_TIME";
  static const String LABEL_OBSERVATION = "LABEL_OBSERVATION";
  static const String LABEL_SWELLING_LOC = "LABEL_SWELLING_LOC";

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 1. Uso de 'late' para inicialização correta
  late TextEditingController _timeController;
  late TextEditingController _bloodPressureController;
  late TextEditingController _weightController;
  late TextEditingController _bpmController;
  late TextEditingController _observationController;
  late TextEditingController _swellingLocController;

  @override
  void initState() {
    super.initState();

    // Inicialização dos controllers com máscaras
    _timeController = MultimaskedTextController(
      maskDefault: "xx:xx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    _bloodPressureController = MultimaskedTextController(
      escapeCharacter: "#",
      maskDefault: "###x###",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    // Preenchimento de dados existentes
    _formData[LABEL_WEIGHT] = widget.biometric.weight?.toString();
    _formData[LABEL_BPM] = widget.biometric.bpm?.toString();
    _formData[LABEL_BLOOD_PRESSURE] = widget.biometric.bloodPressure;
    _formData[LABEL_SWELLING] = widget.biometric.swelling;
    _formData[LABEL_SWELLING_LOC] = widget.biometric.swellingLocalization;
    _formData[LABEL_FATIGUE] = widget.biometric.fatigue;
    _formData[LABEL_OBSERVATION] = widget.biometric.observation;
    _formData[LABEL_TIME] = DateHelper.getTimeFromDate(widget.biometric.executedDate);

    _timeController.text = _formData[LABEL_TIME] ?? "";
    _bloodPressureController.text = _formData[LABEL_BLOOD_PRESSURE] ?? "";

    _weightController = TextEditingController(text: _formData[LABEL_WEIGHT]);
    _bpmController = TextEditingController(text: _formData[LABEL_BPM]);
    _observationController = TextEditingController(text: _formData[LABEL_OBSERVATION]);
    _swellingLocController = TextEditingController(text: _formData[LABEL_SWELLING_LOC]);
  }

  @override
  void dispose() {
    _timeController.dispose();
    _bloodPressureController.dispose();
    _weightController.dispose();
    _bpmController.dispose();
    _observationController.dispose();
    _swellingLocController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Biometric>, GenericState<Biometric>>(
          listener: (context, state) {
            if (state is Error<Biometric>) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is Loaded<Biometric>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Biometric>, GenericState<Biometric>>(
            builder: (context, state) {
              if (state is Loading<Biometric>) {
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
            isRequired: true,
            keyboardType: TextInputType.number,
            textEditingController: _weightController,
            hintText: Strings.weight_hint,
            title: Strings.weight_title,
            onChanged: (value) => setState(() => _formData[LABEL_WEIGHT] = value),
          ),
          CustomTextFormField(
            isRequired: true,
            keyboardType: TextInputType.number,
            textEditingController: _bpmController,
            hintText: Strings.bpm_hint,
            title: Strings.bpm_title,
            onChanged: (value) => setState(() => _formData[LABEL_BPM] = value),
          ),
          CustomTextFormField(
            isRequired: true,
            textEditingController: _bloodPressureController,
            keyboardType: TextInputType.number,
            hintText: Strings.blood_pressure_hint,
            title: Strings.blood_pressure_title,
            onChanged: (value) => setState(() => _formData[LABEL_BLOOD_PRESSURE] = value),
          ),
          CustomSelector(
            title: Strings.swelling,
            options: Arrays.swelling.keys.toList(),
            subtitle: _formData[LABEL_SWELLING],
            onChanged: (value) {
              setState(() {
                _formData[LABEL_SWELLING] = Arrays.swelling.keys.toList()[value];
              });
            },
          ),
          if (_formData[LABEL_SWELLING] != null &&
              _formData[LABEL_SWELLING] != "Nenhum" &&
              _formData[LABEL_SWELLING] != "Selecione")
            CustomTextFormField(
              isRequired: true,
              hintText: Strings.swelling_loc_hint,
              textEditingController: _swellingLocController,
              title: Strings.swelling_loc_title,
              onChanged: (value) => setState(() => _formData[LABEL_SWELLING_LOC] = value),
            ),
          CustomSelector(
            title: Strings.fatigue,
            options: Arrays.fatigue.keys.toList(),
            subtitle: _formData[LABEL_FATIGUE],
            onChanged: (value) {
              setState(() {
                _formData[LABEL_FATIGUE] = Arrays.fatigue.keys.toList()[value];
              });
            },
          ),
          CustomTextFormField(
            isRequired: true,
            keyboardType: TextInputType.number,
            textEditingController: _timeController,
            hintText: Strings.time_hint,
            title: Strings.time_title,
            onChanged: (value) => setState(() => _formData[LABEL_TIME] = value),
          ),
          CustomTextFormField(
            textEditingController: _observationController,
            hintText: Strings.observation_hint,
            title: Strings.observation,
            onChanged: (value) => setState(() => _formData[LABEL_OBSERVATION] = value),
          ),
          SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
          Button(
            title: (!widget.biometric.done) ? Strings.add : Strings.edit_patient_done,
            onTap: () => _submitForm(context),
          ),
          SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
        ],
      ),
    );
  }

  void _submitForm(BuildContext context) {
    // 2. Validação segura do Form
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_formData[LABEL_SWELLING] == null || Arrays.swelling[_formData[LABEL_SWELLING]] == null) {
      _showError(context, "Favor selecionar o inchaço");
      return;
    }
    if (_formData[LABEL_FATIGUE] == null || Arrays.fatigue[_formData[LABEL_FATIGUE]] == null) {
      _showError(context, "Favor selecionar a fadiga");
      return;
    }

    _formKey.currentState?.save();

    // 3. Repasse das datas obrigatórias da recomendação original
    final executedBiometric = Biometric(
      id: widget.biometric.id,
      done: true,
      initialDate: widget.biometric.initialDate, // OBRIGATÓRIO
      finalDate: widget.biometric.finalDate,     // OBRIGATÓRIO
      frequency: widget.biometric.frequency,
      times: widget.biometric.times,
      weight: int.tryParse(_formData[LABEL_WEIGHT] ?? "0") ?? 0,
      bpm: int.tryParse(_formData[LABEL_BPM] ?? "0") ?? 0,
      bloodPressure: _formData[LABEL_BLOOD_PRESSURE] ?? "",
      swellingLocalization: _formData[LABEL_SWELLING_LOC] ?? "",
      swelling: _formData[LABEL_SWELLING] ?? "",
      fatigue: _formData[LABEL_FATIGUE] ?? "",
      observation: _formData[LABEL_OBSERVATION] ?? "",
      executedDate: DateHelper.addTimeToCurrentDate(_formData[LABEL_TIME]),
    );

    if (!widget.biometric.done) {
      BlocProvider.of<GenericBloc<Biometric>>(context).add(
        ExecuteEvent<Biometric>(entity: executedBiometric),
      );
    } else {
      BlocProvider.of<GenericBloc<Biometric>>(context).add(
        EditExecutedEvent<Biometric>(entity: executedBiometric),
      );
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
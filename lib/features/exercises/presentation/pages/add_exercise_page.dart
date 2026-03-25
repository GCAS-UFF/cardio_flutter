import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/core/widgets/times_list.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardio_flutter/core/widgets/custom_selector.dart';

class AddExercisePage extends StatefulWidget {
  final Exercise? exercise; // 1. Opcional para criação

  const AddExercisePage({super.key, this.exercise});

  @override
  State<StatefulWidget> createState() {
    return _AddExercisePageState();
  }
}

class _AddExercisePageState extends State<AddExercisePage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_FREQUENCY = "LABEL_FREQUENCY";
  static const String LABEL_INTENSITY = "LABEL_INTENSITY";
  static const String LABEL_DURATION = "LABEL_DURATION";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";
  static const String LABEL_BODY_PAIN = "LABEL_BODY_PAIN";
  static const String LABEL_DIZZINESS = "DIZZINESS";
  static const String LABEL_SHORTNESS_OF_BREATH = "LABEL_SHORTNESS_OF_BREATH";
  static const String LABEL_EXCESSIVE_FATIGUE = "LABEL_EXCESSIVE_FATIGUE";
  static const String LABEL_EXECUTIONDAY = "LABEL_EXECUTIONDAY";
  static const String LABEL_TIMES = "LABEL_TIMES";
  static const String LABEL_OBSERVATION = "LABEL_OBSERVATION";

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Controladores marcados como late para inicialização no initState
  late TextEditingController _nameController;
  late TextEditingController _frequencyController;
  late TextEditingController _durationController;
  late final TextEditingController _initialDateController;
  late final TextEditingController _finalDateController;

  @override
  void initState() {
    super.initState();

    // Inicialização dos controladores com máscaras
    _initialDateController = MultimaskedTextController(
      maskDefault: "xx/xx/xxxx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    _finalDateController = MultimaskedTextController(
      maskDefault: "xx/xx/xxxx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    if (widget.exercise != null) {
      final ex = widget.exercise!;
      _formData[LABEL_NAME] = ex.name;
      _formData[LABEL_FREQUENCY] = ex.frequency.toString();
      _formData[LABEL_INTENSITY] = ex.intensity;
      _formData[LABEL_TIMES] = ex.times;
      _formData[LABEL_DURATION] = ex.durationInMinutes.toString();
      _formData[LABEL_INITIAL_DATE] = DateHelper.convertDateToString(ex.initialDate);
      _formData[LABEL_FINAL_DATE] = DateHelper.convertDateToString(ex.finalDate);

      _initialDateController.text = _formData[LABEL_INITIAL_DATE] ?? "";
      _finalDateController.text = _formData[LABEL_FINAL_DATE] ?? "";
    }

    _nameController = TextEditingController(text: _formData[LABEL_NAME]);
    _frequencyController = TextEditingController(text: _formData[LABEL_FREQUENCY]);
    _durationController = TextEditingController(text: _formData[LABEL_DURATION]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _initialDateController.dispose();
    _finalDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<ExerciseBloc, ExerciseState>(
          listener: (context, state) {
            if (state is Error) {
              // 3. ScaffoldMessenger corrigido
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is Loaded) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<ExerciseBloc, ExerciseState>(
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
              hintText: Strings.phycical_activity_hint,
              title: Strings.phycical_activity,
              onChanged: (value) => setState(() => _formData[LABEL_NAME] = value),
            ),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              textEditingController: _frequencyController,
              hintText: Strings.hint_frequency,
              title: Strings.frequency,
              onChanged: (value) => setState(() => _formData[LABEL_FREQUENCY] = value),
            ),
            TimeList(
                frequency: (_formData[LABEL_FREQUENCY] != null && _formData[LABEL_FREQUENCY] != "")
                    ? int.parse(_formData[LABEL_FREQUENCY])
                    : 0,
                onChanged: (times) => setState(() => _formData[LABEL_TIMES] = times),
                initialvalues: _formData[LABEL_TIMES]),
            CustomSelector(
              title: Strings.intensity,
              options: Arrays.intensities.keys.toList(),
              subtitle: _formData[LABEL_INTENSITY],
              onChanged: (value) {
                setState(() {
                  _formData[LABEL_INTENSITY] = Arrays.intensities.keys.toList()[value];
                });
              },
            ),
            CustomTextFormField(
              isRequired: true,
              textEditingController: _durationController,
              hintText: Strings.hint_duration,
              title: Strings.duration,
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() => _formData[LABEL_DURATION] = value),
            ),
            CustomTextFormField(
              isRequired: true,
              textEditingController: _initialDateController,
              keyboardType: TextInputType.number,
              validator: DateInputValidator(),
              hintText: Strings.date,
              title: Strings.initial_date,
              onChanged: (value) => setState(() => _formData[LABEL_INITIAL_DATE] = value),
            ),
            CustomTextFormField(
              isRequired: true,
              textEditingController: _finalDateController,
              keyboardType: TextInputType.number,
              validator: DateInputValidator(),
              hintText: Strings.date,
              title: Strings.final_date,
              onChanged: (value) => setState(() => _formData[LABEL_FINAL_DATE] = value),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
            Button(
              title: (widget.exercise == null) ? Strings.add : Strings.edit_patient_done,
              onTap: () => _submitForm(context),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
          ],
        ));
  }

  void _submitForm(BuildContext context) {
    // 4. Validação do formulário com Null Safety
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_formData[LABEL_INTENSITY] == null || Arrays.intensities[_formData[LABEL_INTENSITY]] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favor selecionar a intensidade")),
      );
      return;
    }

    _formKey.currentState?.save();

    // 5. Garantia de datas não-nulas para a Entidade
    final initial = DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]) ?? DateTime.now();
    final finalD = DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]) ?? DateTime.now();

    final List timesList = (_formData[LABEL_TIMES] as List? ?? []);

    final exerciseEntity = Exercise(
      id: widget.exercise?.id,
      name: _formData[LABEL_NAME] ?? "",
      done: false,
      intensity: _formData[LABEL_INTENSITY] ?? "",
      durationInMinutes: int.tryParse(_formData[LABEL_DURATION] ?? "0") ?? 0,
      frequency: int.tryParse(_formData[LABEL_FREQUENCY] ?? "0") ?? 0,
      initialDate: initial,
      finalDate: finalD,
      times: timesList.map((time) => Converter.convertStringToMaskedString(mask: "xx:xx", value: time)).toList(),
      // Campos de execução opcionais
      dizziness: _formData[LABEL_DIZZINESS],
      shortnessOfBreath: _formData[LABEL_SHORTNESS_OF_BREATH],
      bodyPain: _formData[LABEL_BODY_PAIN],
      excessiveFatigue: _formData[LABEL_EXCESSIVE_FATIGUE],
      observation: _formData[LABEL_OBSERVATION],
    );

    if (widget.exercise == null) {
      BlocProvider.of<ExerciseBloc>(context).add(AddExerciseEvent(exercise: exerciseEntity));
    } else {
      BlocProvider.of<ExerciseBloc>(context).add(EditExerciseProfessionalEvent(exercise: exerciseEntity));
    }
  }
}
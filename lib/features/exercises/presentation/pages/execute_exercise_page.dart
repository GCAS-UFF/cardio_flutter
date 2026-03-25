import 'package:cardio_flutter/core/input_validators/time_of_day_validator.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardio_flutter/core/widgets/custom_selector.dart';

class ExecuteExercisePage extends StatefulWidget {
  final Exercise exercise;

  // 1. Uso do required nativo e super.key
  const ExecuteExercisePage({super.key, required this.exercise});

  @override
  State<StatefulWidget> createState() {
    return _ExecuteExercisePageState();
  }
}

class _ExecuteExercisePageState extends State<ExecuteExercisePage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_INTENSITY = "LABEL_INTENSITY";
  static const String LABEL_DURATION = "LABEL_DURATION";
  static const String LABEL_BODY_PAIN = "LABEL_BODY_PAIN";
  static const String LABEL_DIZZINESS = "DIZZINESS";
  static const String LABEL_SHORTNESS_OF_BREATH = "LABEL_SHORTNESS_OF_BREATH";
  static const String LABEL_EXCESSIVE_FATIGUE = "LABEL_EXCESSIVE_FATIGUE";
  static const String LABEL_TIME_OF_DAY = "LABEL_TIME_OF_DAY";
  static const String LABEL_OBSERVATION = "LABEL_OBSERVATION";

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Controladores marcados como late
  late TextEditingController _nameController;
  late TextEditingController _durationController;
  late TextEditingController _observationController;
  late TextEditingController _timeOfDayController;

  @override
  void initState() {
    super.initState();

    _timeOfDayController = MultimaskedTextController(
      maskDefault: "xx:xx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    _formData[LABEL_NAME] = widget.exercise.name;
    _formData[LABEL_OBSERVATION] = widget.exercise.observation;
    _formData[LABEL_INTENSITY] = widget.exercise.intensity;
    _formData[LABEL_DURATION] = widget.exercise.durationInMinutes.toString();

    if (widget.exercise.done) {
      _formData[LABEL_SHORTNESS_OF_BREATH] = widget.exercise.shortnessOfBreath;
      _formData[LABEL_EXCESSIVE_FATIGUE] = widget.exercise.excessiveFatigue;
      _formData[LABEL_DIZZINESS] = widget.exercise.dizziness;
      _formData[LABEL_BODY_PAIN] = widget.exercise.bodyPain;
    } else {
      _formData[LABEL_SHORTNESS_OF_BREATH] = false;
      _formData[LABEL_EXCESSIVE_FATIGUE] = false;
      _formData[LABEL_DIZZINESS] = false;
      _formData[LABEL_BODY_PAIN] = false;
    }

    _nameController = TextEditingController(text: _formData[LABEL_NAME]);
    _observationController = TextEditingController(text: _formData[LABEL_OBSERVATION]);
    _durationController = TextEditingController(text: _formData[LABEL_DURATION]);
    _timeOfDayController.text = _formData[LABEL_TIME_OF_DAY] ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _observationController.dispose();
    _timeOfDayController.dispose();
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
              hintText: "",
              title: Strings.phycical_activity,
              onChanged: (value) => setState(() => _formData[LABEL_NAME] = value),
            ),
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
              textEditingController: _timeOfDayController,
              validator: TimeOfDayValidator(),
              hintText: Strings.time_hint,
              title: Strings.time_title,
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() => _formData[LABEL_TIME_OF_DAY] = value),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
            Text(
              "Sintomas:",
              style: TextStyle(fontSize: Dimensions.getTextSize(context, 20)),
            ),
            // 3. Ajuste nos Checkboxes para bool?
            CheckboxListTile(
              activeColor: Colors.teal,
              value: _formData[LABEL_SHORTNESS_OF_BREATH] as bool? ?? false,
              onChanged: (bool? value) {
                setState(() => _formData[LABEL_SHORTNESS_OF_BREATH] = value ?? false);
              },
              title: Text(Strings.shortness_of_breath,
                  style: TextStyle(fontSize: Dimensions.getTextSize(context, 15))),
            ),
            CheckboxListTile(
              activeColor: Colors.teal,
              value: _formData[LABEL_EXCESSIVE_FATIGUE] as bool? ?? false,
              onChanged: (bool? value) {
                setState(() => _formData[LABEL_EXCESSIVE_FATIGUE] = value ?? false);
              },
              title: Text(Strings.excessive_fatigue,
                  style: TextStyle(fontSize: Dimensions.getTextSize(context, 15))),
            ),
            CheckboxListTile(
              activeColor: Colors.teal,
              value: _formData[LABEL_DIZZINESS] as bool? ?? false,
              onChanged: (bool? value) {
                setState(() => _formData[LABEL_DIZZINESS] = value ?? false);
              },
              title: Text(Strings.dizziness,
                  style: TextStyle(fontSize: Dimensions.getTextSize(context, 15))),
            ),
            CheckboxListTile(
              activeColor: Colors.teal,
              value: _formData[LABEL_BODY_PAIN] as bool? ?? false,
              onChanged: (bool? value) {
                setState(() => _formData[LABEL_BODY_PAIN] = value ?? false);
              },
              title: Text(Strings.body_pain,
                  style: TextStyle(fontSize: Dimensions.getTextSize(context, 15))),
            ),
            CustomTextFormField(
              textEditingController: _observationController,
              hintText: Strings.observation_hint,
              title: Strings.observation,
              onChanged: (value) => setState(() => _formData[LABEL_OBSERVATION] = value),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
            Button(
              title: (!widget.exercise.done) ? Strings.add : Strings.edit_patient_done,
              onTap: () => _submitForm(context),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
          ],
        ));
  }

  void _submitForm(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_formData[LABEL_INTENSITY] == null || Arrays.intensities[_formData[LABEL_INTENSITY]] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favor selecionar a intensidade")),
      );
      return;
    }
    _formKey.currentState?.save();

    final exerciseData = Exercise(
      id: widget.exercise.id,
      done: true,
      name: _formData[LABEL_NAME] ?? "",
      durationInMinutes: int.tryParse(_formData[LABEL_DURATION]?.toString() ?? "0") ?? 0,
      dizziness: _formData[LABEL_DIZZINESS] as bool? ?? false,
      shortnessOfBreath: _formData[LABEL_SHORTNESS_OF_BREATH] as bool? ?? false,
      bodyPain: _formData[LABEL_BODY_PAIN] as bool? ?? false,
      intensity: _formData[LABEL_INTENSITY] ?? "",
      excessiveFatigue: _formData[LABEL_EXCESSIVE_FATIGUE] as bool? ?? false,
      executionDay: DateTime.now(),
      executionTime: _formData[LABEL_TIME_OF_DAY] ?? "",
      observation: _formData[LABEL_OBSERVATION] ?? "",
      // 4. Repassando as datas obrigatórias da recomendação original
      initialDate: widget.exercise.initialDate,
      finalDate: widget.exercise.finalDate,
    );

    if (!widget.exercise.done) {
      BlocProvider.of<ExerciseBloc>(context).add(ExecuteExerciseEvent(exercise: exerciseData));
    } else {
      BlocProvider.of<ExerciseBloc>(context).add(EditExecutedExerciseEvent(exercise: exerciseData));
    }
  }
}
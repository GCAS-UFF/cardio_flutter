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
import 'package:meta/meta.dart';
import 'package:cardio_flutter/core/widgets/custom_selector.dart';

class ExecuteExercisePage extends StatefulWidget {
  final Exercise exercise;

  const ExecuteExercisePage({@required this.exercise});
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

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _durationController;
  TextEditingController _observationController;
  TextEditingController _timeOfDayController = new MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    _formData[LABEL_NAME] = widget.exercise.name;
    _formData[LABEL_OBSERVATION] = widget.exercise.observation;
    _formData[LABEL_INTENSITY] = widget.exercise.intensity.toString();
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

    _nameController = TextEditingController(
      text: _formData[LABEL_NAME],
    );
    _observationController = TextEditingController(
      text: _formData[LABEL_OBSERVATION],
    );

    _durationController = TextEditingController(
      text: _formData[LABEL_DURATION],
    );
    _timeOfDayController.text = _formData[LABEL_TIME_OF_DAY];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<ExerciseBloc, ExerciseState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              CustomTextFormField(
                textCapitalization: TextCapitalization.words,
                isRequired: true,
                textEditingController: _nameController,
                hintText: "",
                title: Strings.phycical_activity,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_NAME] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomSelector(
                title: Strings.intensity,
                options: Arrays.intensities.keys.toList(),
                subtitle: _formData[LABEL_INTENSITY],
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_INTENSITY] =
                        Arrays.intensities.keys.toList()[value];
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _durationController,
                hintText: Strings.hint_duration,
                title: Strings.duration,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_DURATION] = value.toString();
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _timeOfDayController,
                validator: TimeofDayValidator(),
                hintText: Strings.time_hint,
                title: Strings.time_title,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_TIME_OF_DAY] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Container(
                padding: Dimensions.getEdgeInsetsSymetric(context, horizontal: 25),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sintomas:",
                  style: TextStyle(fontSize: Dimensions.getTextSize(context, 20)),
                ),
              ),
              CheckboxListTile(
                activeColor: Colors.teal,
                value: _formData[LABEL_SHORTNESS_OF_BREATH],
                onChanged: (bool value) {
                  setState(() {
                    _formData[LABEL_SHORTNESS_OF_BREATH] = value;
                  });
                },
                title: Text(
                  Strings.shortness_of_breath,
                  style:
                      TextStyle(fontSize: Dimensions.getTextSize(context, 20)),
                ),
              ),
              CheckboxListTile(
                activeColor: Colors.teal,
                value: _formData[LABEL_EXCESSIVE_FATIGUE],
                onChanged: (bool value) {
                  setState(() {
                    _formData[LABEL_EXCESSIVE_FATIGUE] = value;
                  });
                },
                title: Text(
                  Strings.excessive_fatigue,
                  style:
                      TextStyle(fontSize: Dimensions.getTextSize(context, 20)),
                ),
              ),
              CheckboxListTile(
                activeColor: Colors.teal,
                value: _formData[LABEL_DIZZINESS],
                onChanged: (bool value) {
                  setState(() {
                    _formData[LABEL_DIZZINESS] = value;
                  });
                },
                title: Text(
                  Strings.dizziness,
                  style:
                      TextStyle(fontSize: Dimensions.getTextSize(context, 20)),
                ),
              ),
              CheckboxListTile(
                activeColor: Colors.teal,
                value: _formData[LABEL_BODY_PAIN],
                onChanged: (bool value) {
                  setState(() {
                    _formData[LABEL_BODY_PAIN] = value;
                  });
                },
                title: Text(
                  Strings.body_pain,
                  style:
                      TextStyle(fontSize: Dimensions.getTextSize(context, 20)),
                ),
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
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: (!widget.exercise.done)
                    ? Strings.add
                    : Strings.edit_patient_done,
                onTap: () {
                  _submitForm(context);
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
            ],
          ),
        ));
  }

  void _submitForm(context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
     else if (_formData[LABEL_INTENSITY] == null ||
        Arrays.intensities[_formData[LABEL_INTENSITY]] == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Favor selecionar a intensidade"),
        ),
      );
      return;
    }
    _formKey.currentState.save();

    if (!widget.exercise.done) {
      BlocProvider.of<ExerciseBloc>(context).add(
        ExecuteExerciseEvent(
          exercise: Exercise(
            done: true,
            name: _formData[LABEL_NAME],
            durationInMinutes: int.parse(_formData[LABEL_DURATION]),
            dizziness: _formData[LABEL_DIZZINESS],
            shortnessOfBreath: _formData[LABEL_SHORTNESS_OF_BREATH],
            bodyPain: _formData[LABEL_BODY_PAIN],
            intensity: _formData[LABEL_INTENSITY],
            excessiveFatigue: _formData[LABEL_EXCESSIVE_FATIGUE],
            executionDay: DateTime.now(),
            executionTime: _formData[LABEL_TIME_OF_DAY],
            observation: _formData[LABEL_OBSERVATION],
          ),
        ),
      );
    } else {
      BlocProvider.of<ExerciseBloc>(context).add(
        EditExecutedExerciseEvent(
          exercise: Exercise(
            id: widget.exercise.id,
            done: true,
            name: _formData[LABEL_NAME],
            durationInMinutes: int.parse(_formData[LABEL_DURATION]),
            dizziness: _formData[LABEL_DIZZINESS],
            shortnessOfBreath: _formData[LABEL_SHORTNESS_OF_BREATH],
            bodyPain: _formData[LABEL_BODY_PAIN],
            intensity: _formData[LABEL_INTENSITY],
            excessiveFatigue: _formData[LABEL_EXCESSIVE_FATIGUE],
            executionDay: DateTime.now(),
            executionTime: _formData[LABEL_TIME_OF_DAY],
            observation: _formData[LABEL_OBSERVATION],
          ),
        ),
      );
    }
  }
}

import 'package:cardio_flutter/core/input_validators/time_of_day_validator.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_check_item.dart';
import 'package:cardio_flutter/core/widgets/custom_dropdown_form_field.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/cardio_colors.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

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
    maskDefault: "##:##",
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
      recomendation: Strings.exercise,
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
                textCapitalization: TextCapitalization.words,
                isRequired: true,
                textEditingController: _nameController,
                hintText: Strings.phycical_activity_hint,
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
              CustomDropdownFormField(
                title: Strings.intensity,
                dropDownList: Arrays.intensities.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_INTENSITY] = Arrays.intensities['$value'];
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Sintomas",
                    style: TextStyle(
                      color: CardioColors.black,
                      fontSize: Dimensions.getTextSize(context, 20),
                      fontWeight: FontWeight.w500,
                    ),
                    strutStyle: StrutStyle.disabled,
                  ),
                  Container(
                    width: double.infinity,
                    padding: Dimensions.getEdgeInsets(context, left: 15, top: 15, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimensions.getConvertedHeightSize(context, 5),
                      ),
                      border: Border.all(
                        color: CardioColors.black,
                        width: Dimensions.getConvertedHeightSize(context, 1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomCheckItem(
                          label: Strings.shortness_of_breath,
                          value: _formData[LABEL_SHORTNESS_OF_BREATH],
                          onChanged: (bool value) {
                            setState(() {
                              _formData[LABEL_SHORTNESS_OF_BREATH] = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: Dimensions.getConvertedHeightSize(context, 10),
                        ),
                        CustomCheckItem(
                          value: _formData[LABEL_EXCESSIVE_FATIGUE],
                          onChanged: (bool value) {
                            setState(() {
                              _formData[LABEL_EXCESSIVE_FATIGUE] = value;
                            });
                          },
                          label: Strings.excessive_fatigue,
                        ),
                        SizedBox(
                          height: Dimensions.getConvertedHeightSize(context, 10),
                        ),
                        CustomCheckItem(
                          value: _formData[LABEL_DIZZINESS],
                          onChanged: (bool value) {
                            setState(() {
                              _formData[LABEL_DIZZINESS] = value;
                            });
                          },
                          label: Strings.dizziness,
                        ),
                        SizedBox(
                          height: Dimensions.getConvertedHeightSize(context, 10),
                        ),
                        CustomCheckItem(
                          value: _formData[LABEL_BODY_PAIN],
                          onChanged: (bool value) {
                            setState(() {
                              _formData[LABEL_BODY_PAIN] = value;
                            });
                          },
                          label: Strings.body_pain,
                        ),
                      ],
                    ),
                  ),
                ],
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
                title: (!widget.exercise.done) ? Strings.add : Strings.edit_patient_done,
                onTap: () {
                  _submitForm(context);
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

  void _submitForm(context) {
    if (!_formKey.currentState.validate()) {
      return;
    } else if (_formData[LABEL_INTENSITY] == null || Arrays.intensities[_formData[LABEL_INTENSITY]] == null) {
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

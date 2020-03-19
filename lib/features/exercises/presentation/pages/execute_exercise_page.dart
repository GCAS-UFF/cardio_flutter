import 'package:cardio_flutter/core/input_validators/time_of_day_validator.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/exercises/domain/entities/exercise.dart';
import 'package:cardio_flutter/features/exercises/presentation/bloc/exercise_bloc.dart';
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

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _intensityController;
  TextEditingController _durationController;
  TextEditingController _timeOfDayController = new MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    _formData[LABEL_NAME] = widget.exercise.name;
    _formData[LABEL_INTENSITY] = widget.exercise.intensity.toString();
    _formData[LABEL_DURATION] = widget.exercise.durationInMinutes.toString();
    _formData[LABEL_TIME_OF_DAY] = widget.exercise.executionTime;

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

    _intensityController = TextEditingController(
      text: _formData[LABEL_INTENSITY],
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
                height: Dimensions.getConvertedHeightSize(context, 10),
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
              CustomTextFormField(
                isRequired: true,
                textEditingController: _intensityController,
                hintText: "",
                title: Strings.intensity,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_INTENSITY] = value;
                  });
                },
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
              CustomTextFormField(
                isRequired: true,
                textEditingController: _timeOfDayController,
                validator: TimeofDayValidator(),
                hintText: "",
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
              Text(
                "Sintomas:",
                style: TextStyle(fontSize: 20),
              ),
              CheckboxListTile(
                value: _formData[LABEL_SHORTNESS_OF_BREATH],
                onChanged: (bool value) {
                  setState(() {
                    _formData[LABEL_SHORTNESS_OF_BREATH] = value;
                  });
                },
                title: Text(Strings.shortness_of_breath),
              ),
              CheckboxListTile(
                value: _formData[LABEL_EXCESSIVE_FATIGUE],
                onChanged: (bool value) {
                  setState(() {
                    _formData[LABEL_EXCESSIVE_FATIGUE] = value;
                  });
                },
                title: Text(Strings.excessive_fatigue),
              ),
              CheckboxListTile(
                value: _formData[LABEL_DIZZINESS],
                onChanged: (bool value) {
                  setState(() {
                    _formData[LABEL_DIZZINESS] = value;
                  });
                },
                title: Text(Strings.dizziness),
              ),
              CheckboxListTile(
                value: _formData[LABEL_BODY_PAIN],
                onChanged: (bool value) {
                  setState(() {
                    _formData[LABEL_BODY_PAIN] = value;
                  });
                },
                title: Text(Strings.body_pain),
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: Strings.add,
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
        ),
      ),
    );
  }
}

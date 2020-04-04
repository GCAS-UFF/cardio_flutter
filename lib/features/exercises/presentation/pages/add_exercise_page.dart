import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
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

class AddExercisePage extends StatefulWidget {
  final Exercise exercise;

  AddExercisePage({this.exercise});

  @override
  State<StatefulWidget> createState() {
    return _AddExercisePageState();
  }
}

class _AddExercisePageState extends State<AddExercisePage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_FREQUENCY = "LABEL_LABEL_FREQUENCY";
  static const String LABEL_INTENSITY = "LABEL_INTENSITY";
  static const String LABEL_DURATION = "LABEL_DURATION";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";
  static const String LABEL_BODY_PAIN = "LABEL_BODY_PAIN";
  static const String LABEL_DIZZINESS = "DIZZINESS";
  static const String LABEL_SHORTNESS_OF_BREATH = "LABEL_SHORTNESS_OF_BREATH";
  static const String LABEL_EXCESSIVE_FATIGUE = "LABEL_EXCESSIVE_FATIGUE";
  static const String LABEL_EXECUTIONDAY = "LABEL_EXECUTIONDAY";
  static const String LABEL_TIME_OF_DAY = "LABEL_TIME_OF_DAY";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  TextEditingController _nameController;
  TextEditingController _frequencyController;
  TextEditingController _durationController;
  final TextEditingController _initialDateController =
      new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _finalDateController = new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    if (widget.exercise != null) {
      _formData[LABEL_NAME] = widget.exercise.name;
      _formData[LABEL_FREQUENCY] = widget.exercise.frequency.toString();
      _formData[LABEL_INTENSITY] = widget.exercise.intensity;
      _formData[LABEL_DURATION] = widget.exercise.durationInMinutes.toString();
      _formData[LABEL_INITIAL_DATE] =
          DateHelper.convertDateToString(widget.exercise.initialDate);
      _formData[LABEL_FINAL_DATE] =
          DateHelper.convertDateToString(widget.exercise.finalDate);
      _initialDateController.text = _formData[LABEL_INITIAL_DATE];
      _finalDateController.text = _formData[LABEL_FINAL_DATE];
    }
    _nameController = TextEditingController(
      text: _formData[LABEL_NAME],
    );
    _frequencyController = TextEditingController(
      text: _formData[LABEL_FREQUENCY],
    );

    _durationController = TextEditingController(
      text: _formData[LABEL_DURATION],
    );

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
                hintText: Strings.phycical_activity_hint,
                title: Strings.phycical_activity,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_NAME] = value;
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
              CustomSelector(
                title: Strings.intensity,
                options: Arrays.intensities.keys.toList(),
                subtitle: _formData[LABEL_INTENSITY],
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_INTENSITY]
                    =Arrays.intensities.keys.toList()[value];
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
                textEditingController: _initialDateController,
                validator: DateInputValidator(),
                hintText: Strings.date,
                title: Strings.initial_date,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_INITIAL_DATE] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _finalDateController,
                validator: DateInputValidator(),
                hintText: Strings.date,
                title: Strings.final_date,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_FINAL_DATE] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: (widget.exercise == null)
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

    if (widget.exercise == null) {
      BlocProvider.of<ExerciseBloc>(context).add(
        AddExerciseEvent(
          exercise: Exercise(
            name: _formData[LABEL_NAME],
            done: false,
            durationInMinutes: int.parse(_formData[LABEL_DURATION]),
            dizziness: _formData[LABEL_DIZZINESS],
            shortnessOfBreath: _formData[LABEL_SHORTNESS_OF_BREATH],
            bodyPain: _formData[LABEL_BODY_PAIN],
            intensity: _formData[LABEL_INTENSITY],
            excessiveFatigue: _formData[LABEL_EXCESSIVE_FATIGUE],
            frequency: int.parse(_formData[LABEL_FREQUENCY]),
            finalDate:
                DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]),
            initialDate:
                DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
            executionDay:
                DateHelper.convertStringToDate(_formData[LABEL_EXECUTIONDAY]),
          ),
        ),
      );
    } else {
      BlocProvider.of<ExerciseBloc>(context).add(
        EditExerciseProfessionalEvent(
          exercise: Exercise(
            id: widget.exercise.id,
            name: _formData[LABEL_NAME],
            done: false,
            durationInMinutes: int.parse(_formData[LABEL_DURATION]),
            dizziness: _formData[LABEL_DIZZINESS],
            shortnessOfBreath: _formData[LABEL_SHORTNESS_OF_BREATH],
            bodyPain: _formData[LABEL_BODY_PAIN],
            intensity: _formData[LABEL_INTENSITY],
            excessiveFatigue: _formData[LABEL_EXCESSIVE_FATIGUE],
            frequency: int.parse(_formData[LABEL_FREQUENCY]),
            finalDate:
                DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]),
            initialDate:
                DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
            executionDay:
                DateHelper.convertStringToDate(_formData[LABEL_EXECUTIONDAY]),
          ),
        ),
      );
    }
  }
}

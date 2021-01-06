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
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
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
  static const String LABEL_FREQUENCY_PERWEEK = "LABEL_FREQUENCY_PERWEEK";
  static const String LABEL_INTENSITY = "LABEL_INTENSITY";
  static const String LABEL_DURATION = "LABEL_DURATION";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";
  static const String LABEL_TIMES = "LABEL_TIMES";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _frequencyPerWeerController;
  TextEditingController _durationController;
  final TextEditingController _initialDateController =
      new MultimaskedTextController(
    maskDefault: "##/##/####",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _finalDateController = new MultimaskedTextController(
    maskDefault: "##/##/####",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    if (widget.exercise != null) {
      _formData[LABEL_NAME] = widget.exercise.name;
      _formData[LABEL_FREQUENCY_PERWEEK] =
          widget.exercise.frequencyPerWeek.toString();
      _formData[LABEL_INTENSITY] = widget.exercise.intensity;
      _formData[LABEL_TIMES] = widget.exercise.times;
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
    _frequencyPerWeerController = TextEditingController(
      text: _formData[LABEL_FREQUENCY_PERWEEK],
    );

    _durationController = TextEditingController(
      text: _formData[LABEL_DURATION],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.exercise.id);
    return BasePage(
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Exercise>, GenericState<Exercise>>(
          listener: (context, state) {
            if (state is Error<Exercise>) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is Loaded<Exercise>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Exercise>, GenericState<Exercise>>(
            builder: (context, state) {
              print(state);
              if (state is Loading<Exercise>) {
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
                textEditingController: _frequencyPerWeerController,
                hintText: Strings.hint_frequencyExercise,
                title: Strings.frequency,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_FREQUENCY_PERWEEK] = value;
                  });
                },
              ),
              TimeList(
                  frequency: 1,
                  onChanged: (times) {
                    setState(() {
                      _formData[LABEL_TIMES] = times;
                    });
                  },
                  initialvalues: _formData[LABEL_TIMES]),
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
                keyboardType: TextInputType.number,
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
                isRequired: false,
                textEditingController: _finalDateController,
                keyboardType: TextInputType.number,
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
    } else if (_formData[LABEL_INTENSITY] == null ||
        Arrays.intensities[_formData[LABEL_INTENSITY]] == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Favor selecionar a intensidade"),
        ),
      );
      return;
    }
    _formKey.currentState.save();

    if (widget.exercise == null) {
      BlocProvider.of<GenericBloc<Exercise>>(context).add(
        AddRecomendationEvent<Exercise>(
          entity: Exercise(
            name: _formData[LABEL_NAME],
            done: false,
            durationInMinutes: int.parse(_formData[LABEL_DURATION]),
            times: (_formData[LABEL_TIMES] as List)
                .map((time) => Converter.convertStringToMaskedString(
                    mask: "##:##", value: time))
                .toList(),
            intensity: _formData[LABEL_INTENSITY],
            frequency: 1,
            frequencyPerWeek: int.parse(_formData[LABEL_FREQUENCY_PERWEEK]),
            finalDate: _formData[LABEL_FINAL_DATE] != null &&
                    _formData[LABEL_FINAL_DATE] != ""
                ? DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE])
                : DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
            initialDate:
                DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
          ),
        ),
      );
    } else {
      print('2:${widget.exercise.id}');
      BlocProvider.of<GenericBloc<Exercise>>(context).add(
        EditRecomendationEvent<Exercise>(
          entity: Exercise(
            id: widget.exercise.id,
            name: _formData[LABEL_NAME],
            done: false,
            durationInMinutes: int.parse(_formData[LABEL_DURATION]),
            times: (_formData[LABEL_TIMES] as List)
                .map((time) => Converter.convertStringToMaskedString(
                    mask: "##:##", value: time))
                .toList(),
            intensity: _formData[LABEL_INTENSITY],
            frequency: 1,
            frequencyPerWeek: int.parse(_formData[LABEL_FREQUENCY_PERWEEK]),
            finalDate: _formData[LABEL_FINAL_DATE] != null &&
                    _formData[LABEL_FINAL_DATE] != ""
                ? DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE])
                : DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
            initialDate:
                DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
          ),
        ),
      );
    }
  }
}

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

  ExecuteBiometricPage({this.biometric});

  @override
  State<StatefulWidget> createState() {
    return _ExecuteBiometricPageState();
  }
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

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _timeController = new MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _bloodPressureController =
      new MultimaskedTextController(
    escapeCharacter: "#",
    maskDefault: "###x###",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _weightController;
  TextEditingController _bpmController;
  TextEditingController _observationController;
  TextEditingController _swellingLocController;

  @override
  void initState() {
    if (widget.biometric != null) {
      _formData[LABEL_WEIGHT] = (widget.biometric.weight == null)
          ? null
          : widget.biometric.weight.toString();
      _formData[LABEL_BPM] = (widget.biometric.bpm == null)
          ? null
          : widget.biometric.bpm.toString();
      _formData[LABEL_BLOOD_PRESSURE] = widget.biometric.bloodPressure;
      _formData[LABEL_SWELLING] = widget.biometric.swelling;
      _formData[LABEL_SWELLING_LOC] = widget.biometric.swellingLocalization;
      _formData[LABEL_FATIGUE] = widget.biometric.fatigue;
      _formData[LABEL_OBSERVATION] = widget.biometric.observation;
      _formData[LABEL_TIME] =
          DateHelper.getTimeFromDate(widget.biometric.executedDate);
      _timeController.text = _formData[LABEL_TIME];
      _bloodPressureController.text = _formData[LABEL_BLOOD_PRESSURE];
    }

    _weightController = TextEditingController(
      text: _formData[LABEL_WEIGHT],
    );
    _bpmController = TextEditingController(
      text: _formData[LABEL_BPM],
    );
    _observationController = TextEditingController(
      text: _formData[LABEL_OBSERVATION],
    );
    _swellingLocController = TextEditingController(
      text: _formData[LABEL_SWELLING_LOC],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Biometric>, GenericState<Biometric>>(
          listener: (context, state) {
            if (state is Error<Biometric>) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is Loaded<Biometric>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Biometric>, GenericState<Biometric>>(
            builder: (context, state) {
              print(state);
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _weightController,
                hintText: Strings.weight_hint,
                title: Strings.weight_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_WEIGHT] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _bpmController,
                hintText: Strings.bpm_hint,
                title: Strings.bpm_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_BPM] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _bloodPressureController,
                keyboardType: TextInputType.number,
                hintText: Strings.blood_pressure_hint,
                title: Strings.blood_pressure_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_BLOOD_PRESSURE] = value;
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomSelector(
                title: Strings.swelling,
                options: Arrays.swelling.keys.toList(),
                subtitle: _formData[LABEL_SWELLING],
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_SWELLING] =
                        Arrays.swelling.keys.toList()[value];
                  });
                },
              ),
              (_formData[LABEL_SWELLING] == null ||
                      _formData[LABEL_SWELLING] == "Nenhum" ||
                      _formData[LABEL_SWELLING] == "Selecione")
                  ? Container()
                  : CustomTextFormField(
                      isRequired: true,
                      hintText: Strings.swelling_loc_hint,
                      textEditingController: _swellingLocController,
                      title: Strings.swelling_loc_title,
                      enable: true,
                      onChanged: (value) {
                        setState(() {
                          _formData[LABEL_SWELLING_LOC] = value;
                        });
                      },
                    ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomSelector(
                title: Strings.fatigue,
                options: Arrays.fatigue.keys.toList(),
                subtitle: _formData[LABEL_FATIGUE],
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_FATIGUE] =
                        Arrays.fatigue.keys.toList()[value];
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 13),
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _timeController,
                hintText: Strings.time_hint,
                title: Strings.time_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_TIME] = value;
                  });
                },
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
                title: (!widget.biometric.done)
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
    } else if (_formData[LABEL_SWELLING] == null ||
        Arrays.swelling[_formData[LABEL_SWELLING]] == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Favor selecionar o inchaço"),
        ),
      );
      return;
    } else if (_formData[LABEL_FATIGUE] == null ||
        Arrays.fatigue[_formData[LABEL_FATIGUE]] == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Favor selecionar a fadiga"),
        ),
      );
      return;
    }

    _formKey.currentState.save();

    if (!widget.biometric.done) {
      BlocProvider.of<GenericBloc<Biometric>>(context).add(
        ExecuteEvent<Biometric>(
          entity: Biometric(
            done: true,
            weight: int.parse(_formData[LABEL_WEIGHT]),
            bpm: int.parse(_formData[LABEL_BPM]),
            bloodPressure: _formData[LABEL_BLOOD_PRESSURE],
            swellingLocalization: _formData[LABEL_SWELLING_LOC],
            swelling: _formData[LABEL_SWELLING],
            fatigue: _formData[LABEL_FATIGUE],
            observation: _formData[LABEL_OBSERVATION],
            executedDate:
                DateHelper.addTimeToCurrentDate(_formData[LABEL_TIME]),
          ),
        ),
      );
    } else {
      BlocProvider.of<GenericBloc<Biometric>>(context).add(
        EditExecutedEvent<Biometric>(
          entity: Biometric(
            id: widget.biometric.id,
            done: true,
            weight: int.parse(_formData[LABEL_WEIGHT]),
            bpm: int.parse(_formData[LABEL_BPM]),
            bloodPressure: _formData[LABEL_BLOOD_PRESSURE],
            swellingLocalization: _formData[LABEL_SWELLING_LOC],
            swelling: _formData[LABEL_SWELLING],
            observation: _formData[LABEL_OBSERVATION],
            fatigue: _formData[LABEL_FATIGUE],
            executedDate:
                DateHelper.addTimeToCurrentDate(_formData[LABEL_TIME]),
          ),
        ),
      );
    }
  }
}

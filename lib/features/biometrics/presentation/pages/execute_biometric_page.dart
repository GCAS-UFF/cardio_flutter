import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
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

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _timeController = new MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _bloodPressureController =  new MultimaskedTextController(
    escapeCharacter: "e",
    maskDefault: "eexee",
    // onlyDigitsDefault: true,
  ).maskedTextFieldController;
  TextEditingController _weightController;
  TextEditingController _bpmController;
  TextEditingController _swellingController;
  TextEditingController _fatigueController;

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
      _formData[LABEL_FATIGUE] = widget.biometric.fatigue;
      _formData[LABEL_TIME] =
          DateHelper.getTimeFromDate(widget.biometric.executedDate);
      _timeController.text = _formData[LABEL_TIME];
    }

    _weightController = TextEditingController(
      text: _formData[LABEL_WEIGHT],
    );
    _bpmController = TextEditingController(
      text: _formData[LABEL_BPM],
    );
   
    _swellingController = TextEditingController(
      text: _formData[LABEL_SWELLING],
    );
    _fatigueController = TextEditingController(
      text: _formData[LABEL_FATIGUE],
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
                height: Dimensions.getConvertedHeightSize(context, 10),
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
              CustomTextFormField(
                isRequired: true,
                textEditingController: _swellingController,
                hintText: "",
                title: Strings.swelling,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_SWELLING] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _fatigueController,
                hintText: '',
                title: Strings.fatigue,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_FATIGUE] = value;
                  });
                },
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
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: (!widget.biometric.done)
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

    if (!widget.biometric.done) {
      BlocProvider.of<GenericBloc<Biometric>>(context).add(
        ExecuteEvent<Biometric>(
          entity: Biometric(
            done: true,
            weight: int.parse(_formData[LABEL_WEIGHT]),
            bpm: int.parse(_formData[LABEL_BPM]),
            bloodPressure: _formData[LABEL_BLOOD_PRESSURE],
            swelling: _formData[LABEL_SWELLING],
            fatigue: _formData[LABEL_FATIGUE],
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
            swelling: _formData[LABEL_SWELLING],
            fatigue: _formData[LABEL_FATIGUE],
            executedDate:
                DateHelper.addTimeToCurrentDate(_formData[LABEL_TIME]),
          ),
        ),
      );
    }
  }
}

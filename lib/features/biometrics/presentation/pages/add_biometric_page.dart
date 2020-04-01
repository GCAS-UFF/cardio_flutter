import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
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

class AddBiometricPage extends StatefulWidget {
  final Biometric biometric;

  AddBiometricPage({this.biometric});

  @override
  State<StatefulWidget> createState() {
    return _AddBiometricPageState();
  }
}

class _AddBiometricPageState extends State<AddBiometricPage> {
  static const String LABEL_FREQUENCY = "LABEL_FREQUENCY";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _frequencyController;
  final TextEditingController _initialDateController =
      new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  final TextEditingController _finalDateController =
      new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    if (widget.biometric != null) {
      _formData[LABEL_FREQUENCY] = widget.biometric.frequency.toString();
      _formData[LABEL_INITIAL_DATE] =
          DateHelper.convertDateToString(widget.biometric.initialDate);
      _formData[LABEL_FINAL_DATE] =
          DateHelper.convertDateToString(widget.biometric.finalDate);
      _initialDateController.text = _formData[LABEL_INITIAL_DATE];
      _finalDateController.text = _formData[LABEL_FINAL_DATE];
    }

    _frequencyController = TextEditingController(
      text: _formData[LABEL_FREQUENCY],
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
                textEditingController: _frequencyController,
                hintText: Strings.hint_frequency,
                title: Strings.frequency,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_FREQUENCY] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _initialDateController,
                hintText: Strings.date,
                validator: DateInputValidator(),
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
                hintText: Strings.date,
                title: Strings.final_date,
                validator: DateInputValidator(),
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
                title: (widget.biometric == null)
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

    if (widget.biometric == null) {
      BlocProvider.of<GenericBloc<Biometric>>(context).add(
        AddRecomendationEvent<Biometric>(
          entity: Biometric(
            done: false,
            frequency: int.parse(_formData[LABEL_FREQUENCY]),
            finalDate:
                DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]),
            initialDate:
                DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
          ),
        ),
      );
    } else {
      BlocProvider.of<GenericBloc<Biometric>>(context).add(
        EditRecomendationEvent<Biometric>(
          entity: Biometric(
            id: widget.biometric.id,
            done: false,
            frequency: int.parse(_formData[LABEL_FREQUENCY]),
            finalDate:
                DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]),
            initialDate:
                DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
          ),
        ),
      );
    }
  }
}

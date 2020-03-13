import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class AddExercisePage extends StatefulWidget {
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

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _frequencyController;
  TextEditingController _intensityController;
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
    _nameController = TextEditingController(
      text: _formData[LABEL_NAME],
    );
    _frequencyController = TextEditingController(
      text: _formData[LABEL_FREQUENCY],
    );
    _intensityController = TextEditingController(
      text: _formData[LABEL_INTENSITY],
    );
    _durationController = TextEditingController(
      text: _formData[LABEL_DURATION],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(body: _buildForm(context),
    backgroundColor: Color(0xffc9fffd) ,);
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
                textEditingController: _initialDateController,
                validator: DateInputValidator(),
                hintText: Strings.initial_date,
                title: Strings.date,
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
                hintText: Strings.final_date,
                title: Strings.date,
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
                title: Strings.new_patient_done,
                onTap: () {
                  // _submitForm();
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
            ],
          ),
        ));
  }
/* 

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    BlocProvider.of<AuthBloc>(context).add(
      AddExerciseEvent(
        patient: Patient(
          cpf: _formData[LABEL_CPF],
          email: _formData[LABEL_EMAIL],
          name: _formData[LABEL_NAME],
          address: _formData[LABEL_ADRESS],
          birthdate: DateHelper.convertStringToDate(
            _formData[LABEL_BIRTHDATE],
          ),
        ),
      ),
    );
  } */

}

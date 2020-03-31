import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class ExecuteAppointmentPage extends StatefulWidget {
  final Appointment appointment;

  ExecuteAppointmentPage({this.appointment});

  @override
  State<StatefulWidget> createState() {
    return _ExecuteAppointmentPageState();
  }
}

class _ExecuteAppointmentPageState extends State<ExecuteAppointmentPage> {
  static const String LABEL_APPOINTMENT_DATE = "LABEL_APPOINTMENT_DATE";
  static const String LABEL_ID = "LABEL_ID";
  static const String LABEL_TIME_OF_APPOINTMENT = "LABEL_TIME_OF_APPOINTMENT";
  static const String LABEL_ADRESS = "LABEL_ADRESS";
  static const String LABEL_WENT = "LABEL_WENT";
  static const String LABEL_EXPERTISE = "LABEL_EXPERTISE";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _adressController;
  TextEditingController _expertiseController;
  TextEditingController _timeOfAppointmentController =
      new MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  TextEditingController _appointmentDateController =
      new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    if (widget.appointment != null) {
      _formData[LABEL_TIME_OF_APPOINTMENT] =
          DateHelper.convertDateToString(widget.appointment.timeOfAppointment);
      _formData[LABEL_ADRESS] = widget.appointment.adress;
      _formData[LABEL_EXPERTISE] = widget.appointment.expertise;

      _formData[LABEL_APPOINTMENT_DATE] =
          DateHelper.convertDateToString(widget.appointment.appointmentDate);
    }
    _timeOfAppointmentController = TextEditingController(
      text: _formData[LABEL_TIME_OF_APPOINTMENT],
    );
    _adressController = TextEditingController(
      text: _formData[LABEL_ADRESS],
    );
    _expertiseController = TextEditingController(
      text: _formData[LABEL_EXPERTISE],
    );
    _appointmentDateController = TextEditingController(
      text: _formData[LABEL_APPOINTMENT_DATE],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(child: _buildForm(context)),
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
                textEditingController: _appointmentDateController,
                validator: DateInputValidator(),
                hintText: Strings.date,
                enable: false,
                title: Strings.appointment_date,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_APPOINTMENT_DATE] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _timeOfAppointmentController,
                hintText: "",
                enable: false,
                title: Strings.time_of_appointment,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_TIME_OF_APPOINTMENT] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _adressController,
                hintText: "",
                enable: false,
                title: Strings.adress,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_ADRESS] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _expertiseController,
                hintText: "",
                title: Strings.specialty,
                enable: false,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_EXPERTISE] = value();
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _expertiseController,
                hintText: "Mistério",
                title: "Compareceu?",
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_EXPERTISE] = value();
                  });
                },
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: (widget.appointment == null)
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
  }
}

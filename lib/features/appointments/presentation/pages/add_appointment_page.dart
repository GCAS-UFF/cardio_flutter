import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';

import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardio_flutter/core/widgets/custom_selector.dart';

class AddAppointmentPage extends StatefulWidget {
  final Appointment appointment;

  AddAppointmentPage({this.appointment});

  @override
  State<StatefulWidget> createState() {
    return _AddAppointmentPageState();
  }
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  static const String LABEL_APPOINTMENT_DATE = "LABEL_APPOINTMENT_DATE";
  static const String LABEL_TIME_OF_APPOINTMENT = "LABEL_TIME_OF_APPOINTMENT";
  static const String LABEL_ADRESS = "LABEL_ADRESS";
  static const String LABEL_EXPERTISE = "LABEL_EXPERTISE";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _timeOfAppointmentController = new MultimaskedTextController(
    maskDefault: "##:##",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  TextEditingController _appointmentDateController = new MultimaskedTextController(
    maskDefault: "##/##/####",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    if (widget.appointment != null) {
      _formData[LABEL_ADRESS] = widget.appointment.adress;
      _formData[LABEL_EXPERTISE] = widget.appointment.expertise;
      _formData[LABEL_APPOINTMENT_DATE] = DateHelper.convertDateToString(widget.appointment.appointmentDate);
      _formData[LABEL_TIME_OF_APPOINTMENT] = DateHelper.getTimeFromDate(widget.appointment.appointmentDate);
      _timeOfAppointmentController.text = _formData[LABEL_TIME_OF_APPOINTMENT];
      _appointmentDateController.text = _formData[LABEL_APPOINTMENT_DATE];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Appointment>, GenericState<Appointment>>(
          listener: (context, state) {
            if (state is Error<Appointment>) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is Loaded<Appointment>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Appointment>, GenericState<Appointment>>(
            builder: (context, state) {
              print(state);
              if (state is Loading<Appointment>) {
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
                textEditingController: _appointmentDateController,
                validator: DateInputValidator(),
                hintText: Strings.date,
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
                hintText: Strings.time_hint,
                title: Strings.time_of_appointment,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_TIME_OF_APPOINTMENT] = value;
                  });
                },
              ),
              CustomSelector(
                  options: Arrays.expertises.keys.toList(),
                  subtitle: _formData[LABEL_EXPERTISE],
                  title: Strings.specialty,
                  onChanged: (value) {
                    setState(() {
                      _formData[LABEL_EXPERTISE] = Arrays.expertises.keys.toList()[value];
                    });
                  }),
              CustomSelector(
                  options: Arrays.adresses.keys.toList(),
                  subtitle: _formData[LABEL_ADRESS],
                  title: Strings.adress,
                  onChanged: (value) {
                    setState(() {
                      _formData[LABEL_ADRESS] = Arrays.adresses.keys.toList()[value];
                    });
                  }),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: (widget.appointment == null) ? Strings.add : Strings.edit_patient_done,
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
    } else if (_formData[LABEL_EXPERTISE] == null || Arrays.expertises[_formData[LABEL_EXPERTISE]] == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Favor selecionar a especialidade"),
        ),
      );
      return;
    } else if (_formData[LABEL_ADRESS] == null || Arrays.adresses[_formData[LABEL_ADRESS]] == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Favor selecionar o endereço"),
        ),
      );
      return;
    }
    _formKey.currentState.save();

    if (widget.appointment == null) {
      BlocProvider.of<GenericBloc<Appointment>>(context).add(
        AddRecomendationEvent<Appointment>(
          entity: Appointment(
            done: false,
            expertise: _formData[LABEL_EXPERTISE],
            adress: _formData[LABEL_ADRESS],
            appointmentDate: DateHelper.addTimeToDate(
              _formData[LABEL_TIME_OF_APPOINTMENT],
              DateHelper.convertStringToDate(_formData[LABEL_APPOINTMENT_DATE]),
            ),
          ),
        ),
      );
    } else {
      BlocProvider.of<GenericBloc<Appointment>>(context).add(
        EditRecomendationEvent<Appointment>(
          entity: Appointment(
            id: widget.appointment.id,
            done: false,
            expertise: _formData[LABEL_EXPERTISE],
            adress: _formData[LABEL_ADRESS],
            appointmentDate: DateHelper.addTimeToDate(
              _formData[LABEL_TIME_OF_APPOINTMENT],
              DateHelper.convertStringToDate(_formData[LABEL_APPOINTMENT_DATE]),
            ),
          ),
        ),
      );
    }
  }
}

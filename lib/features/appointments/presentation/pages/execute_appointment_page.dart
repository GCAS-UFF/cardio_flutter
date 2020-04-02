import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/appointments/domain/entities/appointment.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExecuteAppointmentPage extends StatefulWidget {
  final Appointment appointment;

  ExecuteAppointmentPage({this.appointment});

  @override
  State<StatefulWidget> createState() {
    return _ExecuteAppointmentPageState();
  }
}

class _ExecuteAppointmentPageState extends State<ExecuteAppointmentPage> {
  static const String LABEL_WENT = "LABEL_WENT";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.appointment != null) {
      _formData[LABEL_WENT] = widget.appointment.went;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(
        child:
            BlocListener<GenericBloc<Appointment>, GenericState<Appointment>>(
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
          child:
              BlocBuilder<GenericBloc<Appointment>, GenericState<Appointment>>(
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
                initialValue: DateHelper.convertDateToString(
                    widget.appointment.appointmentDate),
                hintText: Strings.date,
                enable: false,
                title: Strings.appointment_date,
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                initialValue: DateHelper.getTimeFromDate(
                    widget.appointment.appointmentDate),
                hintText: "",
                enable: false,
                title: Strings.time_of_appointment,
              ),
              CustomTextFormField(
                isRequired: true,
                initialValue: widget.appointment.adress,
                hintText: "",
                enable: false,
                title: Strings.adress,
              ),
              CustomTextFormField(
                isRequired: true,
                initialValue: widget.appointment.expertise,
                hintText: "",
                title: Strings.specialty,
                enable: false,
              ),
              SizedBox(
                height: Dimensions.getTextSize(context, 20),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: Dimensions.getEdgeInsets(context, left: 25),
                  child: Text(
                    Strings.went,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: Dimensions.getTextSize(context, 15)),
                  )),
              Container(
                alignment: Alignment.centerLeft,
                padding: Dimensions.getEdgeInsets(context, left: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                          value: true,
                          activeColor: Colors.teal,
                          groupValue: _formData[LABEL_WENT],
                          onChanged: (went) {
                            print(went);
                            setState(() {
                              _formData[LABEL_WENT] = went;
                            });
                          },
                        ),
                        Text(
                          'Sim',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: Dimensions.getTextSize(context, 15)),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          activeColor: Colors.teal,
                          value: false,
                          groupValue: _formData[LABEL_WENT],
                          onChanged: (went) {
                            print(went);
                            setState(() {
                              _formData[LABEL_WENT] = went;
                            });
                          },
                        ),
                        Text(
                          'Não',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: Dimensions.getTextSize(context, 15)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 20),
              ),
              Button(
                title: "Responder",
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

    BlocProvider.of<GenericBloc<Appointment>>(context).add(
      EditExecutedEvent<Appointment>(
        entity: Appointment(
          id: widget.appointment.id,
          done: true,
          appointmentDate: widget.appointment.appointmentDate,
          went: _formData[LABEL_WENT],
          expertise: widget.appointment.expertise,
          adress: widget.appointment.adress,
          executedDate: DateTime.now(),
        ),
      ),
    );
  }
}

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

  // 1. Adicionado 'required' e 'super.key'
  const ExecuteAppointmentPage({super.key, required this.appointment});

  @override
  State<StatefulWidget> createState() {
    return _ExecuteAppointmentPageState();
  }
}

class _ExecuteAppointmentPageState extends State<ExecuteAppointmentPage> {
  static const String LABEL_WENT = "LABEL_WENT";
  static const String LABEL_JUSTIFICATION = "LABEL_JUSTIFICATION";

  final Map<String, dynamic> _formData = {};
  
  // 2. Marcado como 'late' para inicializar no initState
  late TextEditingController _justificationController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    // Inicializando o controlador com o valor da justificativa, se houver
    _justificationController = TextEditingController(
      text: widget.appointment.justification
    );

    _formData[LABEL_WENT] = widget.appointment.went;
    _formData[LABEL_JUSTIFICATION] = widget.appointment.justification;
  }

  @override
  void dispose() {
    _justificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Appointment>, GenericState<Appointment>>(
          listener: (context, state) {
            if (state is Error<Appointment>) {
              // 3. showSnackBar agora via ScaffoldMessenger
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is Loaded<Appointment>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Appointment>, GenericState<Appointment>>(
            builder: (context, state) {
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
            children: <Widget>[
              SizedBox(height: Dimensions.getConvertedHeightSize(context, 10)),
              CustomTextFormField(
                isRequired: true,
                initialValue: DateHelper.convertDateToString(widget.appointment.appointmentDate),
                hintText: Strings.date,
                enable: false,
                title: Strings.appointment_date,
              ),
              CustomTextFormField(
                isRequired: true,
                initialValue: DateHelper.getTimeFromDate(widget.appointment.appointmentDate),
                hintText: "",
                enable: false,
                title: Strings.time_of_appointment,
              ),
              CustomTextFormField(
                isRequired: true,
                // 4. Corrigido de adress para address
                initialValue: widget.appointment.address,
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
              SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: Dimensions.getEdgeInsets(context, left: 25),
                  child: Text(
                    Strings.went,
                    style: TextStyle(fontSize: Dimensions.getTextSize(context, 15)),
                  )),
              Container(
                alignment: Alignment.centerLeft,
                padding: Dimensions.getEdgeInsets(context, left: 25),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio<bool>(
                          value: true,
                          activeColor: Colors.teal,
                          groupValue: _formData[LABEL_WENT],
                          onChanged: (bool? went) {
                            setState(() => _formData[LABEL_WENT] = went);
                          },
                        ),
                        Text('Sim', style: TextStyle(fontSize: Dimensions.getTextSize(context, 15)))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio<bool>(
                          activeColor: Colors.teal,
                          value: false,
                          groupValue: _formData[LABEL_WENT],
                          onChanged: (bool? went) {
                            setState(() => _formData[LABEL_WENT] = went);
                          },
                        ),
                        Text('Não', style: TextStyle(fontSize: Dimensions.getTextSize(context, 15)))
                      ],
                    ),
                  ],
                ),
              ),
              // 5. Ajuste na lógica de exibição da justificativa
              (_formData[LABEL_WENT] == null || _formData[LABEL_WENT] == true)
                  ? Container()
                  : CustomTextFormField(
                      isRequired: true,
                      hintText: Strings.justification_hint,
                      textEditingController: _justificationController,
                      title: Strings.justification,
                      onChanged: (value) {
                        setState(() => _formData[LABEL_JUSTIFICATION] = value);
                      },
                    ),
              SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
              Button(
                title: "Responder",
                onTap: () => _submitForm(),
              ),
              SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
            ],
          ),
        ));
  }

  void _submitForm() {
    // 6. Null check obrigatório no currentState
    if (!_formKey.currentState!.validate()) return;
    
    _formKey.currentState!.save();

    BlocProvider.of<GenericBloc<Appointment>>(context).add(
      EditExecutedEvent<Appointment>(
        entity: Appointment(
          id: widget.appointment.id,
          done: true,
          appointmentDate: widget.appointment.appointmentDate,
          went: _formData[LABEL_WENT],
          justification: _formData[LABEL_JUSTIFICATION],
          expertise: widget.appointment.expertise,
          // 7. address sincronizado
          address: widget.appointment.address,
          executedDate: DateTime.now(),
        ),
      ),
    );
  }
}
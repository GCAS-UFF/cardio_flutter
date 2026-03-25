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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cardio_flutter/core/widgets/custom_selector.dart';

class AddAppointmentPage extends StatefulWidget {
  // 1. Appointment pode ser nulo se estivermos criando um novo
  final Appointment? appointment;

  const AddAppointmentPage({super.key, this.appointment});

  @override
  State<StatefulWidget> createState() {
    return _AddAppointmentPageState();
  }
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  static const String LABEL_APPOINTMENT_DATE = "LABEL_APPOINTMENT_DATE";
  static const String LABEL_TIME_OF_APPOINTMENT = "LABEL_TIME_OF_APPOINTMENT";
  static const String LABEL_ADDRESS = "LABEL_ADDRESS"; // Corrigido spelling
  static const String LABEL_EXPERTISE = "LABEL_EXPERTISE";

  final Map<String, dynamic> _formData = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Os controllers já vêm inicializados corretamente do MultimaskedTextController
  late final TextEditingController _timeOfAppointmentController =
      MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  late final TextEditingController _appointmentDateController =
      MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    super.initState(); // Sempre chame o super no início
    
    if (widget.appointment != null) {
      final appo = widget.appointment!;
      _formData[LABEL_ADDRESS] = appo.address; // Usando o getter 'address' corrigido
      _formData[LABEL_EXPERTISE] = appo.expertise;
      _formData[LABEL_APPOINTMENT_DATE] =
          DateHelper.convertDateToString(appo.appointmentDate);
      _formData[LABEL_TIME_OF_APPOINTMENT] =
          DateHelper.getTimeFromDate(appo.appointmentDate);
      
      _timeOfAppointmentController.text = _formData[LABEL_TIME_OF_APPOINTMENT];
      _appointmentDateController.text = _formData[LABEL_APPOINTMENT_DATE];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Appointment>, GenericState<Appointment>>(
          listener: (context, state) {
            if (state is Error<Appointment>) {
              // 3. Scaffold.of(context).showSnackBar mudou para ScaffoldMessenger
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
        child: Column(
          children: <Widget>[
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 10)),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              textEditingController: _appointmentDateController,
              validator: DateInputValidator(),
              hintText: Strings.date,
              title: Strings.appointment_date,
              onChanged: (value) {
                setState(() => _formData[LABEL_APPOINTMENT_DATE] = value);
              },
            ),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              textEditingController: _timeOfAppointmentController,
              hintText: Strings.time_hint,
              title: Strings.time_of_appointment,
              onChanged: (value) {
                setState(() => _formData[LABEL_TIME_OF_APPOINTMENT] = value);
              },
            ),
            CustomSelector(
                options: Arrays.expertises.keys.toList(),
                subtitle: _formData[LABEL_EXPERTISE],
                title: Strings.specialty,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_EXPERTISE] =
                        Arrays.expertises.keys.toList()[value];
                  });
                }),
            CustomSelector(
                options: Arrays.adresses.keys.toList(),
                subtitle: _formData[LABEL_ADDRESS],
                title: Strings.adress,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_ADDRESS] =
                        Arrays.adresses.keys.toList()[value];
                  });
                }),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
            Button(
              title: (widget.appointment == null)
                  ? Strings.add
                  : Strings.edit_patient_done,
              onTap: () => _submitForm(context),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
          ],
        ));
  }

  void _submitForm(BuildContext context) {
    // 4.currentState agora é opcional, usamos o '!' para garantir que o form existe
    if (!_formKey.currentState!.validate()) {
      return;
    } else if (_formData[LABEL_EXPERTISE] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favor selecionar a especialidade")),
      );
      return;
    } else if (_formData[LABEL_ADDRESS] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favor selecionar o endereço")),
      );
      return;
    }
    
    _formKey.currentState!.save();

    // 5. Tratamento de nulos na conversão de data
    final convertedDate = DateHelper.convertStringToDate(_formData[LABEL_APPOINTMENT_DATE]);
    if (convertedDate == null) return;

    final appointmentDate = DateHelper.addTimeToDate(
      _formData[LABEL_TIME_OF_APPOINTMENT],
      convertedDate,
    );

    if (appointmentDate == null) return;

    if (widget.appointment == null) {
      BlocProvider.of<GenericBloc<Appointment>>(context).add(
        AddRecomendationEvent<Appointment>(
          entity: Appointment(
            done: false,
            expertise: _formData[LABEL_EXPERTISE],
            address: _formData[LABEL_ADDRESS],
            appointmentDate: appointmentDate,
          ),
        ),
      );
    } else {
      BlocProvider.of<GenericBloc<Appointment>>(context).add(
        EditRecomendationEvent<Appointment>(
          entity: Appointment(
            id: widget.appointment!.id,
            done: false,
            expertise: _formData[LABEL_EXPERTISE],
            address: _formData[LABEL_ADDRESS],
            appointmentDate: appointmentDate,
          ),
        ),
      );
    }
  }
}
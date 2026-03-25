import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/core/widgets/times_list.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/biometrics/domain/entities/biometric.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBiometricPage extends StatefulWidget {
  final Biometric? biometric; // 1. Opcional para criação

  const AddBiometricPage({super.key, this.biometric});

  @override
  State<StatefulWidget> createState() {
    return _AddBiometricPageState();
  }
}

class _AddBiometricPageState extends State<AddBiometricPage> {
  static const String LABEL_FREQUENCY = "LABEL_FREQUENCY";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";
  static const String LABEL_TIMES = "LABEL_TIMES";

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Marcados como late e Controllers inicializados sem 'new'
  late TextEditingController _frequencyController;
  late final TextEditingController _initialDateController =
      MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  late final TextEditingController _finalDateController =
      MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    super.initState();
    if (widget.biometric != null) {
      final bio = widget.biometric!;
      _formData[LABEL_FREQUENCY] = bio.frequency.toString();
      _formData[LABEL_TIMES] = bio.times;
      _formData[LABEL_INITIAL_DATE] = DateHelper.convertDateToString(bio.initialDate);
      _formData[LABEL_FINAL_DATE] = DateHelper.convertDateToString(bio.finalDate);
      
      _initialDateController.text = _formData[LABEL_INITIAL_DATE] ?? "";
      _finalDateController.text = _formData[LABEL_FINAL_DATE] ?? "";
    }

    _frequencyController = TextEditingController(text: _formData[LABEL_FREQUENCY]);
  }

  @override
  void dispose() {
    _frequencyController.dispose();
    _initialDateController.dispose();
    _finalDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Biometric>, GenericState<Biometric>>(
          listener: (context, state) {
            if (state is Error<Biometric>) {
              // 3. ScaffoldMessenger para mensagens
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is Loaded<Biometric>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Biometric>, GenericState<Biometric>>(
            builder: (context, state) {
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
        child: Column(
          children: <Widget>[
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 10)),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              textEditingController: _frequencyController,
              hintText: Strings.hint_frequency,
              title: Strings.frequency,
              onChanged: (value) => setState(() => _formData[LABEL_FREQUENCY] = value),
            ),
            TimeList(
              frequency: (_formData[LABEL_FREQUENCY] != null && _formData[LABEL_FREQUENCY] != "")
                  ? int.parse(_formData[LABEL_FREQUENCY])
                  : 0,
              onChanged: (times) => setState(() => _formData[LABEL_TIMES] = times),
              initialvalues: _formData[LABEL_TIMES], // Volte para tudo minúsculo aqui
            ),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              textEditingController: _initialDateController,
              hintText: Strings.date,
              validator: DateInputValidator(),
              title: Strings.initial_date,
              onChanged: (value) => setState(() => _formData[LABEL_INITIAL_DATE] = value),
            ),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              textEditingController: _finalDateController,
              hintText: Strings.date,
              title: Strings.final_date,
              validator: DateInputValidator(),
              onChanged: (value) => setState(() => _formData[LABEL_FINAL_DATE] = value),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
            Button(
              title: (widget.biometric == null) ? Strings.add : Strings.edit_patient_done,
              onTap: _submitForm,
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
          ],
        ));
  }

  void _submitForm() {
  if (!(_formKey.currentState?.validate() ?? false)) return;
  _formKey.currentState?.save();

  final initial = DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]) ?? DateTime.now();
  final finalD = DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]) ?? DateTime.now();
  final List timesList = (_formData[LABEL_TIMES] as List? ?? []);

  if (widget.biometric == null) {
    // Caso de Adicionar
    BlocProvider.of<GenericBloc<Biometric>>(context).add(
      AddRecomendationEvent<Biometric>(
        entity: Biometric(
          done: false,
          frequency: int.tryParse(_formData[LABEL_FREQUENCY] ?? "0") ?? 0,
          times: timesList
              .map((time) => Converter.convertStringToMaskedString(mask: "xx:xx", value: time))
              .toList(),
          finalDate: finalD,
          initialDate: initial,
        ),
      ),
    );
  } else {
    // Caso de Editar: Passamos o ID original explicitamente no construtor
    BlocProvider.of<GenericBloc<Biometric>>(context).add(
      EditRecomendationEvent<Biometric>(
        entity: Biometric(
          id: widget.biometric!.id, // Pegamos o ID do objeto que veio para edição
          done: false,
          frequency: int.tryParse(_formData[LABEL_FREQUENCY] ?? "0") ?? 0,
          times: timesList
              .map((time) => Converter.convertStringToMaskedString(mask: "xx:xx", value: time))
              .toList(),
          finalDate: finalD,
          initialDate: initial,
        ),
      ),
    );
  }
}
}
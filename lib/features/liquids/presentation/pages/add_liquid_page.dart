import 'package:cardio_flutter/core/input_validators/date_input_validator.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLiquidPage extends StatefulWidget {
  final Liquid? liquid; // 1. Marcado como opcional para permitir criação

  const AddLiquidPage({super.key, this.liquid});

  @override
  State<StatefulWidget> createState() => _AddLiquidPageState();
}

class _AddLiquidPageState extends State<AddLiquidPage> {
  static const String LABEL_MILIMITERS_PER_DAY = "LABEL_MILIMITERS_PER_DAY";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 2. Controladores com late e inicialização correta
  late TextEditingController _milimitersPerDayController;
  late TextEditingController _initialDateController;
  late TextEditingController _finalDateController;

  @override
  void initState() {
    super.initState();

    _initialDateController = MultimaskedTextController(
      maskDefault: "xx/xx/xxxx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    _finalDateController = MultimaskedTextController(
      maskDefault: "xx/xx/xxxx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    if (widget.liquid != null) {
      final liq = widget.liquid!;
      _formData[LABEL_MILIMITERS_PER_DAY] = liq.mililitersPerDay.toString();
      _formData[LABEL_INITIAL_DATE] = DateHelper.convertDateToString(liq.initialDate);
      _formData[LABEL_FINAL_DATE] = DateHelper.convertDateToString(liq.finalDate);
      
      _initialDateController.text = _formData[LABEL_INITIAL_DATE] ?? "";
      _finalDateController.text = _formData[LABEL_FINAL_DATE] ?? "";
    }

    _milimitersPerDayController = TextEditingController(
      text: _formData[LABEL_MILIMITERS_PER_DAY],
    );
  }

  @override
  void dispose() {
    _milimitersPerDayController.dispose();
    _initialDateController.dispose();
    _finalDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: const Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Liquid>, GenericState<Liquid>>(
          listener: (context, state) {
            if (state is Error<Liquid>) {
              // 3. ScaffoldMessenger corrigido
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is Loaded<Liquid>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Liquid>, GenericState<Liquid>>(
            builder: (context, state) {
              if (state is Loading<Liquid>) {
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
            textEditingController: _milimitersPerDayController,
            hintText: Strings.hint_liquid,
            title: Strings.liquid_title,
            onChanged: (value) => setState(() => _formData[LABEL_MILIMITERS_PER_DAY] = value),
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
            title: (widget.liquid == null) ? Strings.add : Strings.edit_patient_done,
            onTap: _submitForm,
          ),
          SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
        ],
      ),
    );
  }

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();

    // 4. Conversão segura de datas para garantir que não sejam nulas
    final initialDate = DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]) ?? DateTime.now();
    final finalDate = DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]) ?? DateTime.now();

    final liquidEntity = Liquid(
      done: false,
      mililitersPerDay: int.tryParse(_formData[LABEL_MILIMITERS_PER_DAY] ?? "0") ?? 0,
      initialDate: initialDate,
      finalDate: finalDate,
      id: widget.liquid?.id,
    );

    if (widget.liquid == null) {
      BlocProvider.of<GenericBloc<Liquid>>(context).add(
        AddRecomendationEvent<Liquid>(entity: liquidEntity),
      );
    } else {
      BlocProvider.of<GenericBloc<Liquid>>(context).add(
        EditRecomendationEvent<Liquid>(entity: liquidEntity),
      );
    }
  }
}
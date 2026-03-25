import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_selector.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/generic_feature/presentation/bloc/generic_bloc.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/resources/arrays.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExecuteLiquidPage extends StatefulWidget {
  final Liquid liquid;

  // Correção: required nativo e super.key
  const ExecuteLiquidPage({super.key, required this.liquid});

  @override
  State<StatefulWidget> createState() {
    return _ExecuteLiquidPageState();
  }
}

class _ExecuteLiquidPageState extends State<ExecuteLiquidPage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_QUANTITY = "LABEL_QUANTITY";
  static const String LABEL_REFERENCE = "LABEL_REFERENCE";
  static const String LABEL_TIME = "LABEL_TIME";

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Correção: late initialization
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();

    _timeController = MultimaskedTextController(
      maskDefault: "xx:xx",
      onlyDigitsDefault: true,
    ).maskedTextFieldController;

    // Inicialização dos dados vindos da recomendação
    _formData[LABEL_NAME] = widget.liquid.name;
    _formData[LABEL_QUANTITY] = widget.liquid.quantity?.toString();
    _formData[LABEL_REFERENCE] = widget.liquid.reference;
    _formData[LABEL_TIME] = DateHelper.getTimeFromDate(widget.liquid.executedDate);
    
    _timeController.text = _formData[LABEL_TIME] ?? "";
    _nameController = TextEditingController(text: _formData[LABEL_NAME]);
    _quantityController = TextEditingController(text: _formData[LABEL_QUANTITY]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _timeController.dispose();
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
              // Correção: ScaffoldMessenger para SnackBars
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
              textEditingController: _nameController,
              hintText: "",
              title: Strings.liquid,
              onChanged: (value) => setState(() => _formData[LABEL_NAME] = value),
            ),
            CustomSelector(
              title: Strings.reference,
              options: Arrays.reference.keys.toList(),
              subtitle: _formData[LABEL_REFERENCE],
              onChanged: (value) {
                setState(() {
                  _formData[LABEL_REFERENCE] = Arrays.reference.keys.toList()[value];
                });
              },
            ),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              textEditingController: _quantityController,
              hintText: (Arrays.reference[_formData[LABEL_REFERENCE]] == null)
                  ? ""
                  : "Quantidade de ${_formData[LABEL_REFERENCE]}",
              title: Strings.quantity,
              onChanged: (value) => setState(() => _formData[LABEL_QUANTITY] = value),
            ),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              textEditingController: _timeController,
              hintText: Strings.time_hint,
              title: Strings.time_title,
              onChanged: (value) => setState(() => _formData[LABEL_TIME] = value),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
            Button(
              title: (!widget.liquid.done) ? Strings.add : Strings.edit_patient_done,
              onTap: () => _submitForm(context),
            ),
            SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
          ],
        ));
  }

  void _submitForm(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_formData[LABEL_REFERENCE] == null || Arrays.reference[_formData[LABEL_REFERENCE]] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favor selecionar a referência")),
      );
      return;
    }
    
    _formKey.currentState?.save();

    final liquidData = Liquid(
      id: widget.liquid.id,
      done: true,
      name: _formData[LABEL_NAME] ?? "",
      quantity: int.tryParse(_formData[LABEL_QUANTITY]?.toString() ?? "0") ?? 0,
      reference: _formData[LABEL_REFERENCE] ?? "",
      executedDate: DateHelper.addTimeToCurrentDate(_formData[LABEL_TIME]),
      // Repassando datas obrigatórias da recomendação
      initialDate: widget.liquid.initialDate,
      finalDate: widget.liquid.finalDate,
    );

    if (!widget.liquid.done) {
      BlocProvider.of<GenericBloc<Liquid>>(context).add(
        ExecuteEvent<Liquid>(entity: liquidData),
      );
    } else {
      BlocProvider.of<GenericBloc<Liquid>>(context).add(
        EditExecutedEvent<Liquid>(entity: liquidData),
      );
    }
  }
}
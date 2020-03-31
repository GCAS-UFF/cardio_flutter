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
  final Liquid liquid;

  AddLiquidPage({this.liquid});

  @override
  State<StatefulWidget> createState() {
    return _AddLiquidPageState();
  }
}

class _AddLiquidPageState extends State<AddLiquidPage> {
  static const String LABEL_MILIMITERS_PER_DAY = "LABEL_MILIMITERS_PER_DAY";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_QUANTITY = "LABEL_QUANTITY";
  static const String LABEL_REFERENCE = "LABEL_REFERENCE";
  static const String LABEL_TIME = "LABEL_TIME";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _milimitersPerDayController;
  TextEditingController _initialdateController = new MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  TextEditingController _finalDateController = new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    if (widget.liquid != null) {
      _formData[LABEL_MILIMITERS_PER_DAY] = widget.liquid.mililitersPerDay;
      _formData[LABEL_INITIAL_DATE] =
          DateHelper.convertDateToString(widget.liquid.initialDate);
      _formData[LABEL_FINAL_DATE] =
          DateHelper.convertDateToString(widget.liquid.finalDate);
    }

    _milimitersPerDayController = TextEditingController(
      text: _formData[LABEL_MILIMITERS_PER_DAY],
    );
    _initialdateController = TextEditingController(
      text: _formData[LABEL_INITIAL_DATE],
    );
    _finalDateController = TextEditingController(
      text: _formData[LABEL_FINAL_DATE],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Color(0xffc9fffd),
      body: SingleChildScrollView(
        child: BlocListener<GenericBloc<Liquid>, GenericState<Liquid>>(
          listener: (context, state) {
            if (state is Error<Liquid>) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is Loaded<Liquid>) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<GenericBloc<Liquid>, GenericState<Liquid>>(
            builder: (context, state) {
              print(state);
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
              textEditingController: _milimitersPerDayController,
              hintText: Strings.hint_liquid,
              title: Strings.liquid_title,
              onChanged: (value) {
                setState(() {
                  _formData[LABEL_MILIMITERS_PER_DAY] = value;
                });
              },
            ),
            CustomTextFormField(
              isRequired: true,
              keyboardType: TextInputType.number,
              textEditingController: _initialdateController,
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
              title: (widget.liquid == null)
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
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    BlocProvider.of<GenericBloc<Liquid>>(context).add(
      AddRecomendationEvent<Liquid>(
        entity: Liquid(
          name: _formData[LABEL_NAME],
          quantity: 0,
          reference: _formData[LABEL_REFERENCE],
          mililitersPerDay: int.parse(_formData[LABEL_MILIMITERS_PER_DAY]),
          finalDate:
              DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]),
          initialDate:
              DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
        ),
      ),
    );
  }
}

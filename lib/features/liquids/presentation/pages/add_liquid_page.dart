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

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _milimitersPerDayController;

  final TextEditingController _initialDateController =
      new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  final TextEditingController _finalDateController =
      new MultimaskedTextController(
    maskDefault: "xx/xx/xxxx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    if (widget.liquid != null) {
      _formData[LABEL_MILIMITERS_PER_DAY] =
          widget.liquid.mililitersPerDay.toString();
      _formData[LABEL_INITIAL_DATE] =
          DateHelper.convertDateToString(widget.liquid.initialDate);
      _formData[LABEL_FINAL_DATE] =
          DateHelper.convertDateToString(widget.liquid.finalDate);
      _initialDateController.text = _formData[LABEL_INITIAL_DATE];
      _finalDateController.text = _formData[LABEL_FINAL_DATE];
    }

    _milimitersPerDayController = TextEditingController(
      text: _formData[LABEL_MILIMITERS_PER_DAY],
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
              textEditingController: _initialDateController,
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

    if (widget.liquid == null) {
      BlocProvider.of<GenericBloc<Liquid>>(context).add(
        AddRecomendationEvent<Liquid>(
          entity: Liquid(
            done: false,
            mililitersPerDay: int.parse(_formData[LABEL_MILIMITERS_PER_DAY]),
            finalDate:
                DateHelper.convertStringToDate(_formData[LABEL_FINAL_DATE]),
            initialDate:
                DateHelper.convertStringToDate(_formData[LABEL_INITIAL_DATE]),
          ),
        ),
      );
    } else {
      BlocProvider.of<GenericBloc<Liquid>>(context).add(
        EditRecomendationEvent<Liquid>(
          entity: Liquid(
            id: widget.liquid.id,
            done: true,
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
}

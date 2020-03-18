import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/liquids/domain/entities/liquid.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class ExecuteLiquidPage extends StatefulWidget {
  final Liquid liquid;

  ExecuteLiquidPage({this.liquid});

  @override
  State<StatefulWidget> createState() {
    return _ExecuteLiquidPageState();
  }
}

class _ExecuteLiquidPageState extends State<ExecuteLiquidPage> {
  static const String LABEL_MILIMITERS_PER_DAY = "LABEL_MILIMITERS_PER_DAY";
  static const String LABEL_INITIAL_DATE = "LABEL_INITIAL_DATE";
  static const String LABEL_FINAL_DATE = "LABEL_FINAL_DATE";
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_QUANTITY = "LABEL_QUANTITY";
  static const String LABEL_REFERENCE = "LABEL_REFERENCE";
  static const String LABEL_TIME = "LABEL_TIME";

  Map<String, dynamic> _formData = Map<String, dynamic>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _quantityController;
  TextEditingController _referenceController;

  TextEditingController _timeController = new MultimaskedTextController(
    maskDefault: "xx:xx",
    onlyDigitsDefault: true,
  ).maskedTextFieldController;

  @override
  void initState() {
    if (widget.liquid != null) {}

    _nameController = TextEditingController(
      text: _formData[LABEL_NAME],
    );
    _quantityController = TextEditingController(
      text: _formData[LABEL_QUANTITY],
    );
    _referenceController = TextEditingController(
      text: _formData[LABEL_REFERENCE],
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
                textEditingController: _nameController,
                hintText: "",
                title: Strings.ingested_liquids,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_NAME] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,
                textEditingController: _quantityController,
                hintText: "",
                title: Strings.quantity,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_QUANTITY] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                textEditingController: _referenceController,
                hintText: "",
                title: Strings.reference,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_REFERENCE] = value;
                  });
                },
              ),
              CustomTextFormField(
                isRequired: true,
                keyboardType: TextInputType.number,

                textEditingController: _timeController,
                hintText: "",
                title: Strings.time_title,
                onChanged: (value) {
                  setState(() {
                    _formData[LABEL_TIME] = value;
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
        ));
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
  }
}

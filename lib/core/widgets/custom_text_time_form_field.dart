import 'package:cardio_flutter/core/input_validators/base_input_validator.dart';
import 'package:cardio_flutter/core/input_validators/empty_input_validator.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class CustomTextTimeFormField extends StatefulWidget {
  // 1. Adicionamos '?' para permitir que sejam nulos se não forem passados
  final TextEditingController? textEditingController;
  final BaseInputValidator? validator;
  final bool isRequired;
  final ValueChanged<String>? onChanged; // Mudamos Function para ValueChanged<String>

  CustomTextTimeFormField({
    this.textEditingController,
    this.validator,
    this.isRequired = true,
    this.onChanged,
  });

  @override
  _CustomTextTimeFormFieldState createState() => _CustomTextTimeFormFieldState();
}

class _CustomTextTimeFormFieldState extends State<CustomTextTimeFormField> {
  bool _shouldValidate = false;

  // 2. Ajuste de assinatura: String? tanto no retorno quanto no parâmetro
  String? _validate(String? value) {
    if (widget.isRequired) { // Removida checagem redundante != null
      String? message = EmptyInputValidator().validate(value);
      if (message != null) return message;
    }

    if (widget.validator != null) {
      return widget.validator!.validate(value); // Adicionado '!' para confirmar que não é nulo
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 3. Nome corrigido para Symmetric
      padding: Dimensions.getEdgeInsetsSymmetric(context, horizontal: 5),
      child: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.indigo, offset: Offset(3, 3), blurRadius: 5)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: Dimensions.getConvertedHeightSize(context, 50),
            width: Dimensions.getConvertedWidthSize(context, 70),
            alignment: Alignment.centerLeft,
          ),
          SizedBox( // Container trocado por SizedBox (mais eficiente para largura fixa)
            width: Dimensions.getConvertedWidthSize(context, 70),
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: widget.textEditingController,
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.getTextSize(context, 20),
              ),
              keyboardType: TextInputType.number,
              // 4. autovalidate virou autovalidateMode
              autovalidateMode: _shouldValidate 
                  ? AutovalidateMode.always 
                  : AutovalidateMode.disabled,
              decoration: InputDecoration(
                hintText: Strings.time_hint,
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: Dimensions.getTextSize(context, 15.0),
                ),
                hintStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: Dimensions.getTextSize(context, 20),
                ),
                counterText: "",
                border: InputBorder.none,
              ),
              validator: _validate,
              onChanged: (val) {
                if (!_shouldValidate) setState(() => _shouldValidate = true);
                if (widget.onChanged != null) widget.onChanged!(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
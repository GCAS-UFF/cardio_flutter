import 'package:cardio_flutter/core/input_validators/time_of_day_validator.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/custom_text_time_form_field.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class TimeList extends StatelessWidget {
  final int frequency;
  // 1. Tipamos a função para receber a lista de strings
  final void Function(List<String>) onChanged;
  final List<String>? initialvalues;

  // 2. Trocamos @required por required e removemos meta.dart
  const TimeList({
    super.key,
    required this.frequency,
    required this.onChanged,
    required this.initialvalues,
  });

  @override
  Widget build(BuildContext context) {
    // 3. frequency não é mais nula, então checamos apenas se é 0
    if (frequency == 0) return const SizedBox();

    return Column(
      children: <Widget>[
        Container(
          height: Dimensions.getConvertedHeightSize(context, 30),
          width: Dimensions.getConvertedWidthSize(context, 300),
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          child: Text(
            "  ${Strings.intended_time}",
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.getTextSize(context, 15),
            ),
          ),
        ),
        Container(
          padding: Dimensions.getEdgeInsets(context, left: 5),
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            padding: Dimensions.getEdgeInsetsAll(context, 5),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildList(context),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildList(BuildContext context) {
    List<String> times;

    // 4. Corrigindo a criação da lista: List(frequency) -> List.filled
    if (initialvalues == null || initialvalues!.length != frequency) {
      times = List<String>.filled(frequency, "");
    } else {
      times = List<String>.from(initialvalues!);
    }

    List<Widget> list = [];
    
    // frequency já é garantida como int e >= 1 aqui pela lógica do build
    for (int i = 0; i < frequency; i++) {
      String currentTime = (times[i].isEmpty) ? "" : times[i];

      TextEditingController textEditingController = MultimaskedTextController(
        maskDefault: "xx:xx",
        onlyDigitsDefault: true,
      ).maskedTextFieldController;

      textEditingController.text = currentTime;

      list.add(
        CustomTextTimeFormField(
          isRequired: true,
          validator: TimeOfDayValidator(),
          textEditingController: textEditingController,
          onChanged: (value) {
            times[i] = value;
            onChanged(times);
          },
        ),
      );
    }
    
    return list.isEmpty ? [const SizedBox()] : list;
  }
}
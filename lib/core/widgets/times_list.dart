import 'package:cardio_flutter/core/input_validators/time_of_day_validator.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/custom_text_time_form_field.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TimeList extends StatelessWidget {
  final int frequency;
  final Function onChanged;
  final List<String> initialvalues;

  TimeList({@required this.frequency, @required this.onChanged, @required this.initialvalues});
  @override
  Widget build(BuildContext context) {
    return (frequency == null || frequency == 0)
        ? Container()
        : Column(
            children: <Widget>[
              (Container(
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
              )),
              Container(
                padding: Dimensions.getEdgeInsets(context, left: 5),
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  padding: Dimensions.getEdgeInsetsAll(context, 5),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildList(
                        context,
                      )),
                ),
              ),
            ],
          );
  }

  List<Widget> _buildList(BuildContext context) {
    List<String> times;
    initialvalues == null || (initialvalues).length != frequency ? times = List<String>(frequency) : times = initialvalues;
    List<Widget> list = [];
    if (frequency != null && frequency >= 1) {
      for (int i = 0; i < frequency; i++) {
        print(i);
        times[i] = (times[i] == null) ? "" : times[i];
        TextEditingController textEditingController = MultimaskedTextController(
          maskDefault: "##:##",
          onlyDigitsDefault: true,
        ).maskedTextFieldController;
        textEditingController.text = times[i];
        list.add(
          CustomTextTimeFormField(
            isRequired: true,
            validator: TimeofDayValidator(),
            textEditingController: textEditingController,
            onChanged: (value) {
              times[i] = value;
              onChanged(times);
            },
          ),
        );
      }
    } else {
      list.add(Container());
    }
    return list;
  }
}

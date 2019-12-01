import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class FormCardio extends StatelessWidget {
  final List<Widget> formItems;
  final Function submitForm;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String buttonTitle;

  FormCardio(
      {@override this.formItems, @required this.submitForm, this.buttonTitle})
      : assert(
          formItems != null,
          submitForm != null,
        );

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Column(
            children: formItems.map(
              (widget) {
                return Container(
                  margin: Dimensions.getEdgeInsets(context, bottom: 15),
                  child: widget,
                );
              },
            ).toList(),
          ),
          Container(
            margin: Dimensions.getEdgeInsets(context, top: 15),
            child: Button(
              title: buttonTitle,
              onTap: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                submitForm();
              },
            ),
          )
        ],
      ),
    );
  }
}

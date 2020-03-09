import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final baseWidget;

  LoadingWidget(this.baseWidget);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        baseWidget,
        CircularProgressIndicator(),
      ],
    );
  }
}

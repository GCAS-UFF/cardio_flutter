import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/strings.dart';
import '../../resources/dimensions.dart';

class DialogWidget extends StatelessWidget {
  final String text;
  // 1. Mudamos para VoidCallback para bater com o tipo esperado pelo TextButton
  final VoidCallback onPressed;

  // 2. Trocamos @required por required e removemos o import de meta (se houvesse)
  DialogWidget({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: Colors.red,
            size: Dimensions.getConvertedHeightSize(context, 25),
          ),
          const SizedBox(width: 10), // Adicionado um espacinho entre o ícone e o texto
          Text(
            Strings.warning,
            style: TextStyle(
              fontSize: Dimensions.getTextSize(context, 22),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      content: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.black,
          fontSize: Dimensions.getTextSize(context, 15),
        ),
      ),
      actions: <Widget>[
        // 3. FlatButton agora é TextButton
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            Strings.cancel,
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getTextSize(context, 15)),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            Strings.okbutton,
            style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.getTextSize(context, 15)),
          ),
        ),
      ],
    );
  }
}
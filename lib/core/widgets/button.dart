import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

// 1. Removi o import de widgets.dart porque o material.dart já inclui tudo o que precisamos.

class Button extends StatelessWidget {
  final String title;
  
  // 2. Mudei de Function para VoidCallback, que é o tipo padrão que o InkWell/Buttons esperam.
  final VoidCallback onTap;

  // 3. @required -> required. 
  // 4. Removi o 'assert' porque, se é 'required' e não tem '?', o Dart já garante que não é nulo.
  Button({
    required this.title, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.indigo, 
              offset: Offset(3, 3), 
              blurRadius: 5,
            )
          ], 
          borderRadius: BorderRadius.circular(5), 
          color: Colors.teal,
        ),
        height: Dimensions.getConvertedHeightSize(context, 50),
        width: Dimensions.getConvertedWidthSize(context, 180),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimensions.getTextSize(context, 20),
          ),
        ),
      ),
    );
  }
}
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/images.dart';

class ItemMenu extends StatelessWidget {
  final String text;
  final String image;
  // 1. Mudamos de Function para VoidCallback? (o ? indica que pode ser nulo)
  final VoidCallback? destination;

  // 2. Usamos a sintaxe 'super.key' que é mais moderna e resolve o erro do Key
  const ItemMenu({
    super.key, 
    this.text = "", 
    this.image = Images.app_logo, 
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimensions.getEdgeInsetsAll(context, 8),
      child: InkWell(
        onTap: destination,
        child: Container(
          decoration: const BoxDecoration( // Adicionado const para performance
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: Offset(3, 3),
                color: Colors.indigo,
                blurRadius: 3,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)), // Ajuste leve na sintaxe
          ),
          alignment: Alignment.topLeft,
          width: Dimensions.getConvertedWidthSize(context, 300),
          height: Dimensions.getConvertedHeightSize(context, 45),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: Dimensions.getConvertedWidthSize(context, 5),
              ),
              Padding(
                padding: Dimensions.getEdgeInsetsAll(context, 2),
                child: Image.asset(image),
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: Dimensions.getTextSize(context, 15),
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
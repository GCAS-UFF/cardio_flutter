import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cardio_flutter/resources/dimensions.dart';

class CustomSelector extends StatelessWidget {
  final String title;
  final List<String> options;
  // 1. Mudamos de Function para ValueChanged<int>, que é o que o CupertinoPicker espera
  final ValueChanged<int> onChanged;
  final String? subtitle; // 2. Subtitle pode ser nulo

  const CustomSelector({
    required this.title,
    required this.options,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: Dimensions.getConvertedHeightSize(context, 30),
          width: Dimensions.getConvertedWidthSize(context, 300),
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          child: Text(
            "  $title",
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.getTextSize(context, 15),
            ),
          ),
        ),
        InkWell(
          child: Container(
            // 3. Atenção: Corrigi 'Symetric' para 'Symmetric' (confira no seu arquivo Dimensions se o nome do método está certo lá também!)
            margin: Dimensions.getEdgeInsetsSymmetric(context, horizontal: 15),
            padding: Dimensions.getEdgeInsetsSymmetric(context, horizontal: 15),
            decoration: BoxDecoration(
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.indigo, offset: Offset(3, 3), blurRadius: 5)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  (subtitle == null) ? "Selecione" : subtitle!,
                  style: TextStyle(
                    fontSize: Dimensions.getTextSize(context, 20),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down)
              ],
            ),
            height: Dimensions.getConvertedHeightSize(context, 50),
            alignment: Alignment.centerLeft,
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    title: SizedBox( // Container trocado por SizedBox (mais leve aqui)
                      width: MediaQuery.of(context).size.width,
                      height: Dimensions.getConvertedHeightSize(context, 150),
                      child: CupertinoPicker.builder(
                        useMagnifier: true,
                        childCount: options.length,
                        backgroundColor: Colors.white54,
                        itemExtent:
                            Dimensions.getConvertedHeightSize(context, 50),
                        onSelectedItemChanged: onChanged,
                        diameterRatio: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              options[index],
                              style: TextStyle(
                                  fontSize:
                                      Dimensions.getTextSize(context, 20)),
                            ),
                          );
                        },
                      ),
                    ),
                    actions: <Widget>[
                      Container(
                        margin: Dimensions.getEdgeInsets(context,
                            bottom: 10, right: 10),
                        // 4. FlatButton agora é TextButton
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Ok",
                            style: TextStyle(
                                fontSize: Dimensions.getTextSize(context, 15)),
                          ),
                        ),
                        alignment: Alignment.center,
                      )
                    ],
                  );
                });
          },
        ),
      ],
    );
  }
}
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:flutter/material.dart';

class ClickableItem extends StatefulWidget {
  final String title;
  final InlineSpan text;
  // 1. Mudamos para final para respeitar a imutabilidade do widget
  final bool initialIsClicked;

  // 2. Usamos 'required' e 'super.key'
  const ClickableItem({
    super.key,
    required this.title,
    required this.text,
    this.initialIsClicked = false,
  });

  @override
  _ClickableItemState createState() => _ClickableItemState();
}

class _ClickableItemState extends State<ClickableItem> {
  // 3. O estado real da variável mora aqui no State
  late bool _isClicked;

  @override
  void initState() {
    super.initState();
    // Inicializamos com o valor passado pelo widget pai
    _isClicked = widget.initialIsClicked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            // 4. Invertemos o valor de forma simples
            _isClicked = !_isClicked;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 2),
              borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          // 5. Usamos a variável local _isClicked
          child: (_isClicked)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: Dimensions.getTextSize(context, 16),
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min, // Ajuste para não ocupar a tela toda
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.indigo[900],
                            fontSize: Dimensions.getTextSize(context, 16),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        thickness: 2,
                        color: Colors.blueGrey[600],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [widget.text],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.getTextSize(context, 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
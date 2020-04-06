import 'package:flutter/material.dart';

class ClickableItem extends StatefulWidget {
  final String title;
  final String text;
  bool isClicked;

  ClickableItem({this.title, this.text, this.isClicked = false});
  @override
  _ClickableItemState createState() => _ClickableItemState();
}

class _ClickableItemState extends State<ClickableItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
          onTap: () {
            setState(() {
              (widget.isClicked)
                  ? widget.isClicked = false
                  : widget.isClicked = true;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: (widget.isClicked)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
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
                          child: Text(
                            widget.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        )
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.indigo[900],
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ))),
    );
  }
}

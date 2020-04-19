import 'package:cardio_flutter/resources/dimensions.dart';
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
      padding: const EdgeInsets.all(5.0),
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
              border: Border.all(color: Colors.black54, width: 2),
              borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: (widget.isClicked)
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
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                      fontSize: Dimensions.getTextSize(context, 16),
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

class RichClickableItem extends StatefulWidget {
  final String title;
  final Widget text;
  bool isClicked;

  RichClickableItem({this.title, this.text, this.isClicked = false});
  @override
  _RichClickableItemState createState() => _RichClickableItemState();
}

class _RichClickableItemState extends State<RichClickableItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
              border: Border.all(color: Colors.black54, width: 2),
              borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: (widget.isClicked)
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
                        padding: const EdgeInsets.all(8.0), child: widget.text)
                  ],
                ),
        ),
      ),
    );
  }
}

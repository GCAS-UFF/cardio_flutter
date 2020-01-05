import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class PgFoudation extends StatelessWidget {

final Widget body;
final Color backgroundColor;

  const PgFoudation({Key key, this.body, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/");
            },
            icon: Icon(
              Icons.exit_to_app,
            ),
          ),
          Text("    ")
        ],
        title: Text(
          Strings.app_name,
          style: TextStyle(fontSize: Dimensions.getTextSize(context, 20)),
        ),
        backgroundColor: Colors.lightBlueAccent[100],
      ),
    );
  }
}

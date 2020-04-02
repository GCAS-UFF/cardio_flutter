import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  final Widget body;
  final Color backgroundColor;
  final bool signOutButton;
  final Function addFunction;

  const BasePage({
    Key key,
    this.body,
    this.backgroundColor,
    this.signOutButton = true,
    this.addFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (addFunction != null)
          ? ((Provider.of<Settings>(context, listen: false).getUserType() ==
                  Keys.PROFESSIONAL_TYPE)
              ? FloatingActionButton(
                  onPressed: addFunction,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.lightBlueAccent[200],
                )
              : null)
          : null,
      body: body,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        actions: <Widget>[
          (signOutButton)
              ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/");
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                  ),
                )
              : Container()
        ],
        title: Text(
          Strings.app_name,
          style: TextStyle(
              fontSize: Dimensions.getTextSize(context, 20),
              color: Colors.black87),
        ),
        backgroundColor: Colors.lightBlueAccent[100],
      ),
    );
  }
}

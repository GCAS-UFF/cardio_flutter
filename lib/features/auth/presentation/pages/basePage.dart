import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final Widget body;
  final Color backgroundColor;
  final bool signOutButton;

  const BasePage({
    Key key,
    this.body,
    this.backgroundColor,
    this.signOutButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        actions: <Widget>[
          (signOutButton)
              ? Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/");
                      },
                      icon: Icon(
                        Icons.exit_to_app,
                      ),
                    ),
                  ],
                )
              : Container()

          /*  IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/");
            },
            icon: Icon(
              Icons.exit_to_app,
            ),
          ),
          Text("    ") */
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

Widget SignOutButton(signOutButton, context) {
  bool signOutButton;
  context = context;
  if (signOutButton) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, "/");
      },
      icon: Icon(
        Icons.exit_to_app,
      ),
    );
  } else {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, "/");
      },
      icon: Icon(
        Icons.exit_to_app,
      ),
    );
  }
}

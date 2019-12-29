import 'package:flutter/material.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/signup_page.dart';
import 'package:cardio_flutter/resources/strings.dart';

class DialogLoginPage extends StatefulWidget {
  @override
  _DialogLoginPageState createState() => _DialogLoginPageState();
}

class _DialogLoginPageState extends State<DialogLoginPage> {
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
          ),
          Text(Strings.warning),
        ],
      ),
      backgroundColor: Colors.white,
      content: Text(
        Strings.signup_warning,
        textAlign: TextAlign.justify,
        style: TextStyle(
            color: Colors.indigo[900],
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            Strings.cancel,
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return SignUpPage();
            }));
          },
          child: Text(
            Strings.okbutton,
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }
}
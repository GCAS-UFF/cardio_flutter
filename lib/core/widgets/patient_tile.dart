import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';

class PatientTile extends StatefulWidget {
  @override
  _PatientTileState createState() => _PatientTileState();
}

class _PatientTileState extends State<PatientTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(
          title: Padding(
            padding: Dimensions.getEdgeInsetsAll(context, 5),
            child: Text(
              "Zé Bonitinho",
              style: TextStyle(fontSize: Dimensions.getTextSize(context, 18)),
            ),
          ),
          leading: CircleAvatar(
            radius: Dimensions.getConvertedHeightSize(context, 25),
            child: Text(
              "Z",
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.getTextSize(context, 20),
              ),
            ),
            backgroundColor: Color(0xffc9fffd),
          ),
          trailing: Icon(
            Icons.arrow_right,
            size: Dimensions.getConvertedHeightSize(context, 50),
          ),
          subtitle: RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.grey[600], fontSize: Dimensions.getTextSize(context, 12)),
                children: <TextSpan>[
                  TextSpan(text: Strings.cpf_title),
                  TextSpan(text: Strings.cpf_number),
                  TextSpan(text: Strings.adress),
                  TextSpan(text: Strings.adress_patient),
                  TextSpan(text: Strings.birth),
                  TextSpan(text: Strings.birth_date),
                ]),
          ),
        ),
      ],
    );
  }
}

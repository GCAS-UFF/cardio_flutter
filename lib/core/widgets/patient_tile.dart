import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';

class PatientTile extends StatefulWidget {
  @override
  _PatientTileState createState() => _PatientTileState();
}

class _PatientTileState extends State<PatientTile> {
  @override
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimensions.getEdgeInsetsAll(context, 8),
      child: ExpansionTile(
        
        children: <Widget>[
          RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: Dimensions.getTextSize(context, 12)),
                children: <TextSpan>[
                  TextSpan(text: Strings.cpf_title),
                  TextSpan(text: Strings.cpf_number),
                  TextSpan(text: Strings.adress),
                  TextSpan(text: Strings.adress_patient),
                  TextSpan(text: Strings.birth),
                  TextSpan(text: Strings.birth_date),
                  TextSpan(text: "\n"),
                ]),
          ),
        ],
        title: Padding(
          padding: Dimensions.getEdgeInsetsAll(context, 5),
          child: Text(
            "Paciente Exemplo",
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
        trailing: IconButton(
          icon: Icon(
            Icons.arrow_right,
            size: Dimensions.getConvertedHeightSize(context, 50),
          ),
          onPressed: () {
            
            return Navigator.pushNamed(context, "/menuPage");
          },
        ),
      ),
    );
  }
}

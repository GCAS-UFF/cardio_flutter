import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';

class PatientTile extends StatefulWidget {
  final Patient patient;

  PatientTile({@required this.patient});
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
                  TextSpan(
                      text: Converter.convertStringToMaskedString(
                          value: widget.patient.cpf, mask: "xxx.xxx.xxx-xx")),
                  TextSpan(text: Strings.adress),
                  TextSpan(text: widget.patient.address),
                  TextSpan(text: Strings.birth),
                  TextSpan(
                      text: DateHelper.convertDateToString(
                          widget.patient.birthdate)),
                  TextSpan(text: "\n"),
                ]),
          ),
        ],
        title: Padding(
          padding: Dimensions.getEdgeInsetsAll(context, 5),
          child: Text(
            widget.patient.name,
            style: TextStyle(fontSize: Dimensions.getTextSize(context, 18)),
          ),
        ),
        leading: CircleAvatar(
          radius: Dimensions.getConvertedHeightSize(context, 25),
          child: Text(
            widget.patient.name.substring(0, 1).toUpperCase(),
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
            return Navigator.pushNamed(context, "/homePatientPage");
          },
        ),
      ),
    );
  }
}

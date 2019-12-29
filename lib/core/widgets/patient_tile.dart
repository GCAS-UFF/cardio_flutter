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
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Zé Bonitinho",style: TextStyle(fontSize: Dimensions.getTextSize(context, 18)),),
                ),
                leading: CircleAvatar(radius: 30,
                  child: Text("Z",style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  backgroundColor: Colors.teal[800],
                ),
                trailing: Icon(Icons.arrow_right,size: Dimensions.getConvertedHeightSize(context, 50),),
                subtitle: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey[600]),
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
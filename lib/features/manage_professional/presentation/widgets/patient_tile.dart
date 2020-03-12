import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/manage_professional/data/repositories/manage_professional_repository_impl.dart';
import 'package:cardio_flutter/features/manage_professional/domain/repositories/manage_professional_repository.dart';
import 'package:cardio_flutter/features/manage_professional/domain/usecases/delete_patient_list.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';

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
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: Dimensions.getEdgeInsetsAll(context, 8),
          child: Row(
            children: <Widget>[
              Container(
                width: Dimensions.getConvertedHeightSize(context, 60),
                height: Dimensions.getConvertedWidthSize(context, 60),
                child: CircleAvatar(
                    backgroundColor: Color(0xffc9fffd),
                    radius: Dimensions.getConvertedHeightSize(context, 25),
                    child: Text(
                      widget.patient.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.getTextSize(context, 20),
                      ),
                    )),
              ),
              Padding(
                padding: Dimensions.getEdgeInsetsAll(context, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (widget.patient.name != null) ? widget.patient.name : "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      (widget.patient.email != null) ? widget.patient.name : "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      (DateHelper.convertDateToString(
                                  widget.patient.birthdate) !=
                              null)
                          ? DateHelper.convertDateToString(
                              widget.patient.birthdate)
                          : "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, widget.patient );
      },

    );
  }
}

 void _showOptions(BuildContext context, Patient patient) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: () {

                            Navigator.popAndPushNamed(context, "/homePatientPage");
                          },
                          child: Text(
                            "Abrir",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: () {
                            
                          },
                          child: Text(
                            "Editar",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: () {

                            ManageProfessionalRepositoryImpl.deletePatientList(patient);
                          },
                          child: Text(
                            "Excluir ",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
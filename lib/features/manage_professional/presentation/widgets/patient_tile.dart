import 'package:cardio_flutter/core/platform/mixpanel.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/home_patient_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/patient_sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/bloc/manage_professional_bloc.dart' as professional;
import 'package:flutter_bloc/flutter_bloc.dart';

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
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      (widget.patient.cpf != null) ? Converter.convertStringToMaskedString(value: widget.patient.cpf, mask: "###.###.###-##") : "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      (DateHelper.convertDateToString(widget.patient.birthdate) != null)
                          ? "${DateHelper.ageFromDate(widget.patient.birthdate).toString()} anos"
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
      onTap: () {
        DateTime now = DateTime.now().toUtc().add(
              Duration(seconds: 10),
            );
        _showOptions(
          context,
          widget.patient,
        );
      },
    );
  }
}

void _showOptions(
  BuildContext context,
  Patient patient,
) {
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
                          Navigator.pop(context);
                          Mixpanel.trackEvent(
                            MixpanelEvents.OPEN_PATIENT,
                            data: {"patientId": patient.id},
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePatientPage(patient: patient)),
                          );
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
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientSignUpPage(
                                patient: patient,
                              ),
                            ),
                          );
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
                        Navigator.pop(context);
                        BlocProvider.of<professional.ManageProfessionalBloc>(context).add(
                          professional.DeletePatientEvent(
                            patient: patient,
                          ),
                        );
                      },
                      child: Text(
                        "Excluir ",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    },
  );
}

import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/core/utils/date_helper.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/home_patient_page.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/patient_sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/bloc/manage_professional_bloc.dart'
    as professional;
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientTile extends StatefulWidget {
  final Patient patient;

  // 1. Correção: Uso do 'required' nativo e super.key
  const PatientTile({super.key, required this.patient});

  @override
  _PatientTileState createState() => _PatientTileState();
}

class _PatientTileState extends State<PatientTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptions(context, widget.patient),
      child: Card(
        child: Padding(
          padding: Dimensions.getEdgeInsetsAll(context, 8),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: Dimensions.getConvertedHeightSize(context, 60),
                height: Dimensions.getConvertedWidthSize(context, 60),
                child: CircleAvatar(
                  backgroundColor: const Color(0xffc9fffd),
                  radius: Dimensions.getConvertedHeightSize(context, 25),
                  child: Text(
                    // Pegamos a inicial de forma segura
                    (widget.patient.name.isNotEmpty)
                        ? widget.patient.name.substring(0, 1).toUpperCase()
                        : "?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.getTextSize(context, 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: Dimensions.getEdgeInsetsAll(context, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.patient.name, // Checagem removida pois o tipo garante valor
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Converter.convertStringToMaskedString(
                          value: widget.patient.cpf, mask: "xxx.xxx.xxx-xx"),
                      style: const TextStyle(fontSize: 18),
                    ),
                    // Exibição da idade
                    if (widget.patient.birthdate != null)
                      Text(
                        "${DateHelper.ageFromDate(widget.patient.birthdate!)} anos",
                        style: const TextStyle(fontSize: 18),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Função de opções atualizada
void _showOptions(BuildContext context, Patient patient) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // 3. FlatButton -> TextButton
            ListTile(
              leading: const Icon(Icons.open_in_new, color: Colors.blue),
              title: const Text("Abrir", style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePatientPage(patient: patient)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text("Editar", style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientSignUpPage(patient: patient),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Excluir",
                  style: TextStyle(color: Colors.red, fontSize: 20)),
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<professional.ManageProfessionalBloc>(context)
                    .add(professional.DeletePatientEvent(patient: patient));
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
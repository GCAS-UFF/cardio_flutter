import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/domain/entities/patient.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/pages/edit_professional_page.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/bloc/manage_professional_bloc.dart';
import 'package:cardio_flutter/features/manage_professional/presentation/widgets/patient_tile.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flushbar/flushbar.dart';

class HomeProfessionalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ManageProfessionalBloc, ManageProfessionalState>(
      listener: (context, state) {
        if (state is Error) {
          Flushbar(
            message: state.message,
            duration: Duration(seconds: 3),
          )..show(context);
        }
      },
      child: BlocBuilder<ManageProfessionalBloc, ManageProfessionalState>(
        builder: (context, state) {
          if (state is Loading) {
            return LoadingWidget(_buildBody(context, null, null));
          } else if (state is Loaded) {
            return _buildBody(context, state.professional, state.patientList);
          } else {
            return _buildBody(context, null, null);
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, Professional professional,
      List<Patient> patientList) {
    return BasePage(
      edit: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditProfessionalPage(
              professional: professional,
            );
          }));
        },
      ),
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: Dimensions.getConvertedHeightSize(context, 20),
                  width: double.infinity),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: Dimensions.getConvertedWidthSize(context, 280),
                  height: Dimensions.getConvertedHeightSize(context, 60),
                  decoration: BoxDecoration(
                      color: Color(0xffc9fffd),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            offset: Offset(3, 3),
                            color: Colors.blue,
                            blurRadius: 3)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.person_add,
                        //color: Colors.white,
                      ),
                      Text(
                        Strings.new_patient,
                        style: TextStyle(
                            //color: Colors.white,
                            fontSize: Dimensions.getTextSize(context, 18)),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  return Navigator.pushNamed(context, "/patientSignUp");
                },
              ),
              _buildProfessionalHeader(context, professional),
              SizedBox(
                  height: Dimensions.getConvertedHeightSize(context, 10),
                  width: double.infinity),
              _buildPatientList(context, patientList),
              SizedBox(
                height: Dimensions.getConvertedHeightSize(context, 80),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader(
      BuildContext context, Professional professional) {
    if (professional == null) return Container();
    String name = (professional.name != null)
        ? professional.name
        : "Sem Nome Especificado";
    String expertise = ((professional.expertise != null))
        ? professional.expertise
        : "Sem Especialidade Especificada";
    return Padding(
      padding: Dimensions.getEdgeInsetsAll(context, 8),
      child: Text(
        "Profissional: $name\nEspecialidade: $expertise",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Dimensions.getTextSize(context, 18),
        ),
      ),
    );
  }

  Widget _buildPatientList(BuildContext context, List<Patient> patientList) {
    if (patientList == null) return Container();
    patientList.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: patientList.map((patient) {
        return PatientTile(
          patient: patient,
        );
      }).toList(),
    );
  }

  void sortlist(List list) {
    return list.sort((a, b) => a.toString().compareTo(b.toString()));
  }
}

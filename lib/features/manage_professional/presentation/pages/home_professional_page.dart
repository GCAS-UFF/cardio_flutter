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

class HomeProfessionalPage extends StatelessWidget {
  const HomeProfessionalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ManageProfessionalBloc, ManageProfessionalState>(
      listener: (context, state) {
        if (state is Error) {
          // 1. Substituindo Flushbar pelo ScaffoldMessenger (nativo e moderno)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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

  // 2. Parâmetros alterados para opcionais (?) para aceitar os estados de Loading/Empty
  Widget _buildBody(BuildContext context, Professional? professional,
      List<Patient>? patientList) {
    return BasePage(
      edit: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          if (professional != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditProfessionalPage(
                professional: professional,
              );
            }));
          }
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
                onTap: () {
                  // 3. Removido o 'return' desnecessário que causava erro de tipo
                  Navigator.pushNamed(context, "/patientSignUp");
                },
                child: Container(
                  width: Dimensions.getConvertedWidthSize(context, 280),
                  height: Dimensions.getConvertedHeightSize(context, 60),
                  decoration: BoxDecoration(
                      color: const Color(0xffc9fffd),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            offset: Offset(3, 3),
                            color: Colors.blue,
                            blurRadius: 3)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.person_add),
                      Text(
                        Strings.new_patient,
                        style: TextStyle(
                            fontSize: Dimensions.getTextSize(context, 18)),
                      )
                    ],
                  ),
                ),
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
      BuildContext context, Professional? professional) {
    if (professional == null) return const SizedBox.shrink();
    
    // 4. Simplificação com valores padrão (Null-aware)
    String name = professional.name ?? "Sem Nome Especificado";
    String expertise = professional.expertise ?? "Sem Especialidade Especificada";

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

  Widget _buildPatientList(BuildContext context, List<Patient>? patientList) {
    if (patientList == null || patientList.isEmpty) return const SizedBox.shrink();

    // 5. Cópia da lista para ordenação segura (sort altera a lista original)
    final sortedList = List<Patient>.from(patientList);
    sortedList.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sortedList.map((patient) {
        return PatientTile(
          patient: patient,
        );
      }).toList(),
    );
  }
}
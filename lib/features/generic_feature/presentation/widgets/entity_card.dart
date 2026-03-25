import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/features/calendar/presentation/models/activity.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback openExecuted;
  final VoidCallback openRecommendation; // Nome corrigido
  final VoidCallback delete;

  const EntityCard({
    super.key, // Sintaxe moderna para keys
    required this.activity,
    required this.openExecuted,
    required this.openRecommendation,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (!activity.value.done) {
              if (Provider.of<Settings>(context, listen: false).getUserType() ==
                  Keys.PROFESSIONAL_TYPE) {
                _showOptionsProfessional(context);
              } else {
                openExecuted();
              }
            } else {
              if (Provider.of<Settings>(context, listen: false).getUserType() ==
                  Keys.PROFESSIONAL_TYPE) {
                // Profissionais não fazem nada em cards já realizados
              } else {
                _showOptionsPatient(context);
              }
            }
          },
          child: Container(
            padding: Dimensions.getEdgeInsetsFromLTRB(context, 10, 10, 10, 10),
            decoration: BoxDecoration(
              color: (!activity.value.done)
                  ? Colors.lightBlue
                  : Colors.orangeAccent,
              borderRadius: BorderRadius.circular(7),
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (!activity.value.done) ? " Recomendação" : " Realizado",
                    style: TextStyle(
                        fontSize: Dimensions.getTextSize(context, 16),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: activity.informations.entries.map(
                      (entry) {
                        return _buildParameterItem(context, entry);
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.getConvertedHeightSize(context, 10),
        ),
      ],
    );
  }

  Widget _buildParameterItem(BuildContext context, MapEntry entry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          " ${entry.key}:",
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimensions.getTextSize(context, 16),
          ),
        ),
        Text(
          " ${entry.value}",
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimensions.getTextSize(context, 16),
          ),
        )
      ],
    );
  }

  void _showOptionsPatient(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.red),
                title: const Text("Editar", style: TextStyle(color: Colors.red, fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  openExecuted();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Excluir", style: TextStyle(color: Colors.red, fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  delete();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsProfessional(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.red),
                title: const Text("Editar", style: TextStyle(color: Colors.red, fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  openRecommendation();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Excluir", style: TextStyle(color: Colors.red, fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  delete();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
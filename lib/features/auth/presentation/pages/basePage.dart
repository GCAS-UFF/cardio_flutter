import 'package:cardio_flutter/core/platform/settings.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  // 1. Definimos como opcionais (?) os itens que nem toda página terá
  final Widget? body;
  final Widget? edit;
  final Color? backgroundColor;
  final bool signOutButton;
  final VoidCallback? addFunction; // 2. VoidCallback é o tipo correto para botões

  const BasePage({
    super.key, // Sintaxe moderna para chaves
    this.body,
    this.edit,
    this.backgroundColor,
    this.signOutButton = true,
    this.addFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. Lógica do FAB simplificada para evitar ternários aninhados confusos
      floatingActionButton: _buildFab(context),
      body: body,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
        actions: <Widget>[
          if (edit != null) edit!, // 4. 'if' dentro da lista é mais elegante que ternário
          if (signOutButton)
            IconButton(
              onPressed: () => Navigator.pushNamed(context, "/"),
              icon: const Icon(Icons.exit_to_app),
            ),
        ],
        title: Text(
          Strings.app_name,
          style: TextStyle(
            fontSize: Dimensions.getTextSize(context, 20),
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent[100],
      ),
    );
  }

  // Método auxiliar para deixar o código do Scaffold mais limpo
  Widget? _buildFab(BuildContext context) {
    if (addFunction == null) return null;

    final userType = Provider.of<Settings>(context, listen: false).getUserType();
    if (userType != Keys.PROFESSIONAL_TYPE) return null;

    return FloatingActionButton(
      onPressed: addFunction,
      backgroundColor: Colors.lightBlueAccent[200],
      child: const Icon(
        Icons.add,
        color: Colors.black,
      ),
    );
  }
}
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(20)),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "\nSobre",
                    style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    child: Divider(
                      thickness: 3,
                      color: Colors.grey,
                      height: 20,
                    ),
                  ),
                  Text(
                    "Card.IO é um aplicativo para monitoramento de pacientes com Insuficiência Cardíaca Crônica,"
                    "acompanhados em um Programa de Extensão da Univerdade Federal Fluminense,"
                    "denominado Clínica de Insuficiência Cardíaca Coração Valente."
                    "\nEste aplicativo tem como objetivo estimular o paciente a realizar mudanças de comportamento favorecendo o"
                    "contato direto com a equipe de saúde que o acompanha."
                    "\n\n"
                    "Desenvolvido como projeto de Doutorado da Enfermeira Lyvia da Silva Figueiredo", style: TextStyle(fontSize: 15),
                  ),
                  Text("\nColaboradores",
                      style: TextStyle(
                          color: Colors.indigo[900],
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: Divider(
                      thickness: 3,
                      color: Colors.grey,
                      height: 20,
                    ),
                  ),
                  Text(
                    "Idealizadoras\n - Enfermeira Doutoranda Lyvia da Silva Figueiredo\n",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "- Prof Dra Ana Carla Dantas Cavalcanti\n(Escola de Enfermagem/UFF)\n"
                    "- Prof Dra Paula Vanessa Peclat Flores\n(Escola de Enfermagem/UFF)",
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "\nDesenvolvedores\n",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Prof Dr Flávio Luis Seixas\n"
                    "(Instituto de computação/UFF)\n   - José Paulo de Mello Gomes"
                    "\n(Instituto de computação/UFF)\n"
                    " - Kelly Maria Augusta Tavares Bentes"
                    "\n(Instituto de computação/UFF)\n"
                    " - Artur Ladeira Andrade"
                    "\n(Instituto de computação/UFF)\n"
                    " - Larissa Martins dos Blanco"
                    "\n(Instituto de computação/UFF)\n", style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "Design de ícones\n",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Danilo Corrêa\n"
                    "(Escola de Enfermagem/UFF)\n", style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

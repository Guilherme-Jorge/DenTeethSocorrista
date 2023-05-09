import 'package:denteeth/screens/InicioPage.dart';
import 'package:denteeth/screens/DadosContatoPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DenTeeth Socorrista',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InicioPage(title: 'Tela Inicial'),
        '/dados': (context) => const DadosContatoPage(title: 'Informações de Contato'),
      },
    );
  }
}

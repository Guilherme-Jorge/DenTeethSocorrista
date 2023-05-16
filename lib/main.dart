import 'package:denteeth/screens/InicioPage.dart';
import 'package:denteeth/screens/DadosContatoPage.dart';
import 'package:denteeth/screens/ListaAprovados.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/': (context) => const InicioPage(title: 'Bem Vindo ao DenTeeth'),
        '/dados': (context) =>
            const DadosContatoPage(title: 'Informações de Contato'),
        '/lista_aprovados': (context) =>
            const ListaAprovados(title: 'Lista dos Aprovados'),
      },
    );
  }
}

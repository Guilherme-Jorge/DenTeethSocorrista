import 'package:denteeth/screens/CameraUsuario.dart';
import 'package:denteeth/screens/InicioPage.dart';
import 'package:denteeth/screens/DadosContatoPage.dart';
import 'package:denteeth/screens/ListaAprovados.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

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
        '/camera_boca': (context) => TakePictureScreen(camera: camera)
      },
    );
  }
}

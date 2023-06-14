import 'package:denteeth/screens/AvaliarAtendimento.dart';
import 'package:denteeth/screens/CameraBoca.dart';
import 'package:denteeth/screens/CameraCrianca.dart';
import 'package:denteeth/screens/CameraDocumento.dart';
import 'package:denteeth/screens/InicioPage.dart';
import 'package:denteeth/screens/DadosContatoPage.dart';
import 'package:denteeth/screens/ListaAprovados.dart';
import 'package:denteeth/screens/Mapa.dart';
import 'package:denteeth/screens/NotificacaoDesabilitada.dart';
import 'package:denteeth/screens/ReavaliarAtendimento.dart';
import 'package:denteeth/screens/Telefone.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print(
      "Handling a background message: ${message.messageId} | ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));

  final fcmToken = await FirebaseMessaging.instance.getToken();

  debugPrint(fcmToken);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  Location location = Location();

  final permissions = await location.requestPermission();

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DenTeeth Socorrista',
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      initialRoute: '/',
      routes: {
        '/': (context) => const InicioPage(title: 'Bem Vindo ao DenTeeth'),
        '/dados': (context) =>
            const DadosContatoPage(title: 'Insira as informações de contato'),
        '/lista_aprovados': (context) =>
            const ListaAprovados(title: 'Escolha um dos dentistas'),
        '/camera_boca': (context) => CameraBoca(camera: camera),
        '/camera_documento': (context) => CameraDocumento(camera: camera),
        '/camera_crianca': (context) => CameraCrianca(camera: camera),
        '/telefone': (context) => const Telefone(title: 'Telefone'),
        '/avaliacao': (context) =>
            const AvaliarAtendimento(title: 'Avaliar Atendimento'),
        '/reavaliacao': (context) =>
            const ReavaliarAtendimento(title: 'Reavaliar Atendimento'),
        '/mapa': (context) => const Mapa(title: 'Localização do Atendimento'),
        '/notificacao': (context) => const NotificacaoDesabilitada(title: 'Notificacao Desabilitada'),
      },
    );
  }
}

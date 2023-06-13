import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapaArgs {
  final String titulo;
  final String endereco;
  final double lat;
  final double lng;

  MapaArgs(this.titulo, this.endereco, this.lat, this.lng);
}

class InicioPage extends StatefulWidget {
  const InicioPage({super.key, required this.title});

  final String title;

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  @override
  Widget build(BuildContext context) {
    // Mensagem com o app em segudo plano
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'avaliacao') {
        Navigator.pushNamed(context, '/avaliacao');
      }

      if (message.data['type'] == 'mapa') {
        Navigator.pushNamed(context, '/mapa',
            arguments: MapaArgs(
                message.data['titulo'],
                message.data['endereco'],
                double.parse(message.data['lat']),
                double.parse(message.data['lng'])));
      }
    });
    // Mensagem com o app aberto
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      if (message.data['type'] == 'avaliacao') {
        Navigator.pushNamed(context, '/avaliacao');
      }

      if (message.data['type'] == 'mapa') {
        Navigator.pushNamed(context, '/mapa',
            arguments: MapaArgs(
                message.data['titulo'],
                message.data['endereco'],
                double.parse(message.data['lat']),
                double.parse(message.data['lng'])));
      }
    });
    // Mensagem quando o esta fechado
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        if (message.data['type'] == 'avaliacao') {
          Navigator.pushNamed(context, '/avaliacao');
        }

        if (message.data['type'] == 'mapa') {
          Navigator.pushNamed(context, '/mapa',
              arguments: MapaArgs(
                  message.data['titulo'],
                  message.data['endereco'],
                  double.parse(message.data['lat']),
                  double.parse(message.data['lng'])));
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.pacifico()),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Image(image: AssetImage('images/telaInicio.png')),
          const SizedBox(height: 100),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blueAccent),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(0, 6, 0, 6))),
                onPressed: () {
                  Navigator.pushNamed(context, '/camera_boca');
                },
                child: Text('Emergência',
                    style: GoogleFonts.pacifico(
                        textStyle: const TextStyle(
                            color: Colors.white, fontSize: 24)))),
          ),
          const SizedBox(height: 16),
          const SizedBox(
              width: 300,
              child: Text(
                '* Ao fazer o pedido de emergência você está de acordo com os nossos termos de serviços',
                style: TextStyle(fontSize: 12, color: Colors.black38),
                textAlign: TextAlign.center,
              ))
        ]),
      )),
    );
  }
}

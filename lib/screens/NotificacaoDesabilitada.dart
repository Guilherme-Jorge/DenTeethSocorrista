import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

class ScreenArguments {
  final String notificacao;

  ScreenArguments(this.notificacao);
}

class NotificacaoDesabilitada extends StatefulWidget {
  const NotificacaoDesabilitada({super.key, required this.title});

  final String title;

  @override
  State<NotificacaoDesabilitada> createState() =>
      _NotificacaoDesabilitadaState();
}

class _NotificacaoDesabilitadaState extends State<NotificacaoDesabilitada> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Habilite as notificações para utilizar o APP",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 50.0),
            child: Text(
              "Clique no botão voltar após habilitar as notificações",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  AppSettings.openAppSettings();
                },
                child: const Text('Ir para as configurações')),
          ),
        ],
      ),
    );
  }
}

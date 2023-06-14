import 'package:flutter/material.dart';

class ScreenArguments {
  final String notificacao;

  ScreenArguments(this.notificacao);
}

class NotificacaoDesabilitada extends StatefulWidget {
  const NotificacaoDesabilitada({super.key, required this.title});
  @override

  final String title;

  _NotificacaoDesabilitadaState createState() => _NotificacaoDesabilitadaState();
}

class _NotificacaoDesabilitadaState extends State<NotificacaoDesabilitada> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificações Desabilitadas"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Habilite as notificações para utilizar o APP",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0,50.0,15.0,500.0),
            child: Text(
              "Clique no botão voltar após habilitar as notificações",
              style: TextStyle(fontSize: 25),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Text('Voltar')
            ),
          ),
        ],
      ),
    );
  }
}

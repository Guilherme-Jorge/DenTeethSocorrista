import 'package:flutter/material.dart';

class ListaAprovados extends StatefulWidget {
  const ListaAprovados({super.key, required this.title});

  final String title;

  @override
  State<ListaAprovados> createState() => _ListaAprovadosState();
}

class _ListaAprovadosState extends State<ListaAprovados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Estamos procurando profissionais para te auxiliar...',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const Text(
              'N profissionais avisados...',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            Column(
              children: const [
                Text(
                  'Aguardando',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '...',
                  style: TextStyle(fontSize: 64),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

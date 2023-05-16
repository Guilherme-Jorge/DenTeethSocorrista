import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class DadosContatoPage extends StatefulWidget {
  const DadosContatoPage({super.key, required this.title});

  final String title;

  @override
  State<DadosContatoPage> createState() => _DadosContatoPageState();
}

class _DadosContatoPageState extends State<DadosContatoPage> {
  String _nome = "";
  String _telefone = "";
  String _motivo = "";

  void pedirsocorro() async {
    String _response = "";

    if (_motivo.isEmpty) {
      _motivo = "Motivo não informado";
    }

    final result = await FirebaseFunctions.instance
        .httpsCallable('EnviarChamadaEmergencia')
        .call(
      {"nome": _nome, "telefone": _telefone, "motivo": _motivo},
    );
    _response = result.data as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _nome = value;
                    });
                  },
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Nome do socorrista *',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _telefone = value;
                    });
                  },
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Telefone de contato *',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _motivo = value;
                    });
                  },
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: 'Qual o motivo da emergência? (Opcional)',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            Text('Nome: $_nome | Telefone: $_telefone | Motivo: $_motivo'),
            ElevatedButton(
                onPressed: () {}, child: const Text('Pedir socorro imediato')),
          ],
        ),
      )),
    );
  }
}

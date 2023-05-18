import 'dart:ffi';
import 'dart:io';

import 'package:uuid/uuid.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

var uuid = const Uuid();

class ScreenArguments {
  final String image;

  ScreenArguments(this.image);
}

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

  Future<bool> pedirsocorro(String imagePath) async {
    if (_motivo.isEmpty) {
      _motivo = "Motivo não informado";
    }

    File imageFile = File(imagePath);

    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child('${uuid.v1()}-foto-boca');

    await mountainsRef.putFile(imageFile);

    String imageUrl = await mountainsRef.getDownloadURL();

    await FirebaseFunctions.instanceFor(region: 'southamerica-east1')
        .httpsCallable('enviarEmergencia')
        .call({
      "nome": _nome,
      "telefone": _telefone,
      "descricao": _motivo,
      "fotos": imageUrl,
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

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
            ElevatedButton(
                onPressed: () {
                  pedirsocorro(args.image).then((value) =>
                      Navigator.pushNamed(context, '/lista_aprovados'));
                },
                child: const Text('Pedir socorro imediato')),
          ],
        ),
      )),
    );
  }
}

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:uuid/uuid.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'ListaAprovados.dart';

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

  Future<String> pedirsocorro(String imagePath) async {
    if (_motivo.isEmpty) {
      _motivo = "Motivo não informado";
    }

    File imageFile = File(imagePath);

    final storageRef = FirebaseStorage.instance.ref('emergencias');
    final mountainsRef = storageRef.child('${uuid.v1()}-foto-boca');

    await mountainsRef.putFile(imageFile);

    String imageUrl = await mountainsRef.getDownloadURL();

    final result =
        await FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('enviarEmergencia')
            .call({
      "nome": _nome,
      "telefone": _telefone,
      "descricao": _motivo,
      "fotos": imageUrl,
    });

    String response = result.data as String;
    Map<dynamic, dynamic> userData = json.decode(response);
    Map<dynamic, dynamic> userPayload = json.decode(userData['payload']);

    return userPayload['docId'] as String;
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
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _telefone = value;
                    });
                  },
                  maxLength: 15,
                  decoration: const InputDecoration(
                    labelText: 'Telefone de contato *',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  maxLines: 3,
                  minLines: 1,
                  onChanged: (value) {
                    setState(() {
                      _motivo = value;
                    });
                  },
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Qual o motivo da emergência? (Opcional)',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(46, 12, 46, 12))),
                onPressed: () {
                  pedirsocorro(args.image).then((value) => {
                        Navigator.pushNamed(context, '/lista_aprovados',
                            arguments: ScreenArgumentsIdEmergencia(value))
                      });
                },
                child: const Text(
                  'Pedir socorro imediato',
                  style: TextStyle(fontSize: 18),
                )),
          ],
        ),
      )),
    );
  }
}

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:denteeth/screens/CameraBoca.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ListaAprovados.dart';

var uuid = const Uuid();

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
  bool enviandoDados = false;

  Future<String> pedirsocorro(List<String> imagePath) async {
    if (_motivo.isEmpty) {
      _motivo = "Motivo não informado";
    }

    File imageFileBoca = File(imagePath[0]);
    File imageFileDocumento = File(imagePath[1]);
    File imageFileCrianca = File(imagePath[2]);

    final storageRef = FirebaseStorage.instance.ref('emergencias');

    final uuID = uuid.v1();

    final foto1Ref = storageRef.child('$uuID-foto-boca');
    final foto2Ref = storageRef.child('$uuID-foto-documento');
    final foto3Ref = storageRef.child('$uuID-foto-crianca');

    await foto1Ref.putFile(imageFileBoca);
    await foto2Ref.putFile(imageFileDocumento);
    await foto3Ref.putFile(imageFileCrianca);

    String imageUrlBoca = await foto1Ref.getDownloadURL();
    String imageUrlDocumento = await foto2Ref.getDownloadURL();
    String imageUrlCrianca = await foto3Ref.getDownloadURL();

    final fcmToken = await FirebaseMessaging.instance.getToken();

    final result =
        await FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable('enviarEmergencia')
            .call({
      "nome": _nome,
      "telefone": _telefone,
      "descricao": _motivo,
      "fotos": [imageUrlBoca, imageUrlDocumento, imageUrlCrianca],
      "fcmToken": fcmToken,
    });

    String response = result.data as String;
    Map<dynamic, dynamic> userData = json.decode(response);
    Map<dynamic, dynamic> userPayload = json.decode(userData['payload']);

    return userPayload['docId'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CameraArgs;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.pacifico()),
        automaticallyImplyLeading: false,
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
                  decoration: InputDecoration(
                    labelText: 'Nome do socorrista *',
                    labelStyle: GoogleFonts.inter(color: Colors.black),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: const OutlineInputBorder(
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
                  decoration: InputDecoration(
                    labelText: 'Telefone de contato *',
                    labelStyle: GoogleFonts.inter(color: Colors.black),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: const OutlineInputBorder(
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
                  decoration: InputDecoration(
                    labelText: 'Qual o motivo da emergência? (Opcional)',
                    labelStyle: GoogleFonts.inter(color: Colors.black),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(46, 12, 46, 12))),
                  onPressed: () {
                    if (_nome.isNotEmpty && _telefone.isNotEmpty) {
                      if (!enviandoDados) {
                        setState(() {
                          enviandoDados = true;
                        });
                        pedirsocorro(args.imagesPath).then((value) => {
                              Navigator.pushNamed(context, '/lista_aprovados',
                                  arguments: ScreenArgumentsIdEmergencia(value))
                            });
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              children: [
                                SimpleDialogOption(
                                    child: Text(
                                  'Você não preencheu todos os campos obrigatórios.',
                                  style: GoogleFonts.inter(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold),
                                ))
                              ],
                            );
                          });
                    }
                  },
                  child: enviandoDados
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                      : Text(
                          'Pedir socorro imediato',
                          style: GoogleFonts.inter(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
            )
          ],
        ),
      )),
    );
  }
}

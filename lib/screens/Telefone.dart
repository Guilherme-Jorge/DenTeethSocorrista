import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

class ScreenArgumentsTelefone {
  final String nome;
  final String titulo;
  final String endereco;
  final String profissional;

  ScreenArgumentsTelefone(
      this.nome, this.titulo, this.endereco, this.profissional);
}

class Telefone extends StatefulWidget {
  const Telefone({super.key, required this.title});

  final String title;

  @override
  State<Telefone> createState() => _Telefone();
}

class _Telefone extends State<Telefone> {
  bool botaoDesabilitado = false;

  Future<void> enviarLocalizacao(
      String profissional, String titulo, String endereco) async {
    Location location = Location();
    final localizacao = await location.getLocation();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    try {
      FirebaseFunctions.instanceFor(region: 'southamerica-east1')
          .httpsCallable('enviarDadosMapa')
          .call({
        "app": "socorrista",
        "profissional": profissional,
        "titulo": titulo,
        "endereco": endereco,
        "lat": localizacao.latitude.toString(),
        "lng": localizacao.longitude.toString(),
        "fcmToken": fcmToken
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ScreenArgumentsTelefone;

    return Scaffold(
      appBar: AppBar(
        title: Text('Atendimento Aceito', style: GoogleFonts.pacifico()),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/telefone.png'),
              const SizedBox(height: 20),
              SizedBox(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: GoogleFonts.inter(
                              color: Colors.black, fontSize: 28),
                          children: [
                            TextSpan(
                                text: args.nome,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(text: " irá te atender"),
                          ]))),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: 230,
                child: Text(
                  "O profissional tem 1 minuto para te ligar",
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.black38),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: botaoDesabilitado
                            ? MaterialStateProperty.all(Colors.black38)
                            : MaterialStateProperty.all(Colors.blue),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(46, 12, 46, 12))),
                    onPressed: () {
                      if (!botaoDesabilitado) {
                        setState(() {
                          botaoDesabilitado = true;
                        });
                        enviarLocalizacao(
                          args.profissional,
                          args.titulo,
                          args.endereco,
                        );
                      }
                    },
                    child: Text(
                      'Enviar minha localização',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              )
              // espaco da img com o botao
            ],
          ),
        ),
      ),
    );
  }
}

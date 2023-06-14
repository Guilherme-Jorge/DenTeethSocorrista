import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenArguments {
  final String avaliacao;

  ScreenArguments(this.avaliacao);
}

class AvaliarAtendimento extends StatefulWidget {
  const AvaliarAtendimento({super.key, required this.title});

  final String title;

  @override
  State<AvaliarAtendimento> createState() => _AvaliarAtendimentoState();
}

class _AvaliarAtendimentoState extends State<AvaliarAtendimento> {
  int notaAva = 0;
  int notaApp = 0;
  final TextEditingController _textAvaEditingController =
      TextEditingController();
  final TextEditingController _textAppEditingController =
      TextEditingController();

  void _setRatingAva(int rating) {
    setState(() {
      notaAva = rating;
    });
  }

  void _setRatingApp(int rating) {
    setState(() {
      notaApp = rating;
    });
  }

  Future<bool> _submitAvaliacao() async {
    String txtAva = _textAvaEditingController.text;
    String txtApp = _textAppEditingController.text;

    if (txtAva == "" || txtApp == "") {
      return false;
    }

    await FirebaseFunctions.instanceFor(region: 'southamerica-east1')
        .httpsCallable('enviarAvaliacao')
        .call({
      "notaAvaliacao": notaAva,
      "textoAvaliacao": txtAva,
      "notaApp": notaApp,
      "textoApp": txtApp,
      "fcmToken": await FirebaseMessaging.instance.getToken(),
      "profissional": "aqui tera o id do profissional",
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.pacifico()),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Como você avaliaria o atendimento?',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () => _setRatingAva(i),
                      child: Icon(
                        i <= notaAva ? Icons.star : Icons.star_border,
                        size: 50,
                        color: i <= notaAva ? Colors.black : Colors.black45,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Avalie o atendimento",
                        style: GoogleFonts.inter(fontSize: 18),
                      )),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: TextField(
                      controller: _textAvaEditingController,
                      decoration: const InputDecoration(
                        hintText: "Digite aqui:",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      maxLength: 2000,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Como você avaliaria o DenTeeth?',
                    style: GoogleFonts.inter(fontSize: 18),
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () => _setRatingApp(i),
                      child: Icon(
                        i <= notaApp ? Icons.star : Icons.star_border,
                        size: 50,
                        color: i <= notaApp ? Colors.black : Colors.black45,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Escreva o que achou do app",
                        style: GoogleFonts.inter(fontSize: 18),
                      )),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: TextField(
                      controller: _textAppEditingController,
                      decoration: const InputDecoration(
                        hintText: "Digite aqui:",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      maxLength: 2000,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(46, 12, 46, 12))),
                    onPressed: () {
                      _submitAvaliacao().then((value) => {
                            if (value) {Navigator.pop(context)}
                          });
                    },
                    child: Text(
                      'Enviar avaliação',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Não quero avaliar',
                      style: GoogleFonts.inter(
                          fontSize: 18, color: Colors.black38),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

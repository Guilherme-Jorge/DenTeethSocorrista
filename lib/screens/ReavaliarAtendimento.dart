import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenArguments {
  final String avaliacao;

  ScreenArguments(this.avaliacao);
}

class ReavaliarAtendimento extends StatefulWidget {
  const ReavaliarAtendimento({super.key, required this.title});

  final String title;

  @override
  State<ReavaliarAtendimento> createState() => _ReavaliarAtendimentoState();
}

class _ReavaliarAtendimentoState extends State<ReavaliarAtendimento> {
  int notaAva = 0;
  final TextEditingController _textAvaEditingController =
      TextEditingController();

  void _setRatingAva(int rating) {
    setState(() {
      notaAva = rating;
    });
  }

  Future<bool> _submitAvaliacao() async {
    String txtAva = _textAvaEditingController.text;

    if (txtAva == "") {
      return false;
    }

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
                    'O profissional mandou a seguinte observação',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.black12,
                  child: Text(
                    'blbalblablablalblab',
                    style: GoogleFonts.inter(fontSize: 14),
                  )),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Como você reavaliaria seu atendimento',
                    style: GoogleFonts.inter(fontSize: 18),
                  )),
              const SizedBox(height: 10),
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
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Escreva a reavaliação",
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
                      'Enviar Reavaliação',
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    child: Text(
                      'Não quero reavaliar',
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

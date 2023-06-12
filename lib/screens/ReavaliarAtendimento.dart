import 'package:flutter/material.dart';



class ScreenArguments {
  final String reavaliacao;

  ScreenArguments(this.reavaliacao);
}


class ReavaliarAtendimento extends StatefulWidget {
  const ReavaliarAtendimento({super.key, required this.title});
  @override

  final String title;

  _ReavaliarAtendimentoState createState() => _ReavaliarAtendimentoState();
}

class _ReavaliarAtendimentoState extends State<ReavaliarAtendimento> {
  int notaAva = 0;
  int notaApp = 0;
  TextEditingController _textAvaEditingController = TextEditingController();
  TextEditingController _textAppEditingController = TextEditingController();

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

  void _submitAvaliacao() {
    String txtAva = _textAvaEditingController.text;
    String txtApp = _textAppEditingController.text;


    print('Avaliação Atendimento: $notaAva - $txtAva');
    print('Avaliação DenTeeth: $notaApp - $txtApp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reavaliar Atendimento'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Como você Reavaliaria o atendimento?',
                style: TextStyle (fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () => _setRatingAva(i),
                      child: Icon(
                        i <= notaAva ? Icons.star : Icons.star_border,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Escreva uma reavaliação sobre o atendimento",
                  ),
                  SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: TextField(
                      controller: _textAvaEditingController,
                      decoration: InputDecoration(
                        hintText: "Digite aqui:",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      maxLength: 2000,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Como você reavaliaria o DenTeeth?',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () => _setRatingApp(i),
                      child: Icon(
                        i <= notaApp ? Icons.star : Icons.star_border,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Escreva uma reavaliação sobre o DenTeeth",
                  ),
                  SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: TextField(
                      controller: _textAppEditingController,
                      decoration: InputDecoration(
                        hintText: "Digite aqui:",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      maxLength: 2000,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                constraints: BoxConstraints(minWidth: 1000),
                child: ElevatedButton(
                  onPressed: _submitAvaliacao,
                  child: Text('Finalizar'),
                ),
              ),
              SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(minWidth: 1000),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text('Cancelar')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
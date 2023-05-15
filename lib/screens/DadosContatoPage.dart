import 'package:flutter/material.dart';

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

  void pedirsocorro() {}

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
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nome do socorrista *'),
                  onChanged: (value) {
                    setState(() {
                      _nome = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Telefone de contato *'),
                  onChanged: (value) {
                    setState(() {
                      _telefone = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Qual o motivo da emergência? (Opcional)'),
                  onChanged: (value) {
                    setState(() {
                      _motivo = value;
                    });
                  },
                )
              ],
            ),
            Text('Nome: $_nome | Telefone: $_telefone | Motivo: $_motivo'),
            TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.redAccent),
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 100, vertical: 14)),
                ),
                onPressed: () {},
                child: const Text(
                  'Pedir socorro imediato',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )),
          ],
        ),
      )),
    );
  }
}

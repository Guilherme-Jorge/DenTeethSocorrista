import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenArgumentsTelefone {
  final String telefone;

  ScreenArgumentsTelefone(this.telefone);
}

class Telefone extends StatefulWidget {
  const Telefone({super.key, required this.title});

  final String title;

  @override
  State<Telefone> createState() => _Telefone();
}

class _Telefone extends State<Telefone> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ScreenArgumentsTelefone;
    String telefone = args.telefone;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contato Aceito'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/telefone.png'),
            const SizedBox(height: 20), // espaco da img com o botao
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      telefone,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: telefone));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Número copiado.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // espaco da img com o botao
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 25), // espaco dos botoes
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Enviar Localização'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

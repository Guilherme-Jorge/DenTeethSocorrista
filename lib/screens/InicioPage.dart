import 'package:flutter/material.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key, required this.title});

  final String title;

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Image(image: AssetImage('images/telaInicio.png')),
          const SizedBox(height: 26),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.blueAccent),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 14)),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/dados');
              },
              child: const Text(
                'Emergência',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              )),
          const SizedBox(height: 16),
          const Text(
            '* Ao fazer o pedido de emergência você está de acordo com os nossos termos de serviços',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          )
        ]),
      )),
    );
  }
}

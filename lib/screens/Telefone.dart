import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AceitoContato',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Telefone(),
    );
  }
}

class Telefone extends StatelessWidget {

  // usar essa string para passar o telefone na tela
  String Ntelefone = "199993213";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AceitoContato'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/upvotepana1.png'),
            SizedBox(height: 20), // espaco da img com o botao
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      '$Ntelefone',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(width: 5),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: Ntelefone));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // espaco da img com o botao
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text('Cancelar'),
                ),
                SizedBox(width: 25), // espaco dos botoes
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text('Enviar Localização'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        title: Text(widget.title, style: GoogleFonts.pacifico()),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Image(image: AssetImage('images/telaInicio.png')),
          const SizedBox(height: 100),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blueAccent),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(0, 6, 0, 6))),

                onPressed: () {
                  internet_conexao();;
                },
                child: Text('Emergência',
                    style: GoogleFonts.pacifico(
                        textStyle: const TextStyle(
                            color: Colors.white, fontSize: 24)))),
          ),
          const SizedBox(height: 16),
          const SizedBox(
              width: 300,
              child: Text(
                '* Ao fazer o pedido de emergência você está de acordo com os nossos termos de serviços',
                style: TextStyle(fontSize: 12, color: Colors.black38),
                textAlign: TextAlign.center,
              ))
        ]),
      )),
    );
  }
  void internet_conexao() async {
    var conexao_resultado = await (Connectivity().checkConnectivity());
    if (conexao_resultado == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: 'Sem conexão com a internet',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      Navigator.pushNamed(context, '/camera_boca');
    }
  }
}

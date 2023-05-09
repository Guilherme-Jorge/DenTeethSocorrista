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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 100,vertical: 14)),
                  ),
                  onPressed: () {Navigator.pushNamed(context, '/dados');},
                  child: const Text(
                    'Emergência',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                    ),
                  )
              )
            ]
        ),
      ),
    );
  }
}
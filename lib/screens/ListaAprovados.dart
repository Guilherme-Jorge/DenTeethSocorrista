import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:denteeth/screens/Telefone.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ScreenArgumentsIdEmergencia {
  final String emergeId;

  ScreenArgumentsIdEmergencia(this.emergeId);
}

class ListaAprovados extends StatefulWidget {
  const ListaAprovados({super.key, required this.title});

  final String title;

  @override
  State<ListaAprovados> createState() => _ListaAprovadosState();
}

class _ListaAprovadosState extends State<ListaAprovados> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as ScreenArgumentsIdEmergencia;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('respostas')
        .where('emergencia', isEqualTo: args.emergeId)
        .where('status', isEqualTo: 'ACEITA')
        .limit(5)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          const SizedBox(height: 30),
          StreamBuilder(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                if (snapshot.data!.docs.isNotEmpty) {
                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            return Card(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(width: 40.0),
                                  Text(
                                    data['nome'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        FirebaseFunctions.instanceFor(
                                                region: 'southamerica-east1')
                                            .httpsCallable(
                                                'notificarProfissional')
                                            .call({
                                          "profissional": data['profissional']
                                        });

                                        Navigator.pushNamed(
                                            context, '/telefone',
                                            arguments: ScreenArgumentsTelefone(
                                                data['telefone']));
                                      },
                                      child: const Icon(
                                        Icons.done,
                                        color: Colors.greenAccent,
                                        size: 40,
                                      )),
                                  TextButton(
                                      onPressed: () {},
                                      child: const Icon(
                                        Icons.highlight_off,
                                        color: Colors.redAccent,
                                        size: 40,
                                      ))
                                ],
                              ),
                            );
                          })
                          .toList()
                          .cast(),
                    ),
                  );
                }

                return Text('Aguardando aprovação dos dentistas solicitados!');
              }),
        ]));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:denteeth/screens/Telefone.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenArgumentsIdEmergencia {
  final String emergeId;
  final String nome;
  final String telefone;

  ScreenArgumentsIdEmergencia(this.emergeId, this.nome, this.telefone);
}

class ListaAprovados extends StatefulWidget {
  const ListaAprovados({super.key, required this.title});

  final String title;

  @override
  State<ListaAprovados> createState() => _ListaAprovadosState();
}

class _ListaAprovadosState extends State<ListaAprovados> {
  // Notificar o Denstista
  Future<bool> notificarUsuario(
      String profissional, String telefone, String nome) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await FirebaseFunctions.instanceFor(region: 'southamerica-east1')
        .httpsCallable('notificarProfissional')
        .call({
      "profissional": profissional,
      "telefone": telefone,
      "nome": nome,
      "fcmToken": fcmToken
    });

    return true;
  }

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
      body: StreamBuilder(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            if (snapshot.data!.docs.isNotEmpty) {
              return Column(children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                          return Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                0, 6, 0, 6),
                            height: 110,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.black12),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['nome'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          const SizedBox(height: 5),
                                          const Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.blue,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.blue,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.blue,
                                              ),
                                              Icon(
                                                Icons.star_half,
                                                color: Colors.blue,
                                              ),
                                              Icon(
                                                Icons.star_border,
                                                color: Colors.blue,
                                              )
                                            ],
                                          )
                                        ]),
                                    const Row(
                                      children: [
                                        Text(
                                          '20 km ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'da sua localização',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 2.0)),
                                    ),
                                    onPressed: () {
                                      notificarUsuario(data['profissional'],
                                              args.telefone, args.nome)
                                          .then((value) => {
                                                if (value)
                                                  {
                                                    Navigator.pushNamed(
                                                        context, '/telefone',
                                                        arguments: ScreenArgumentsTelefone(
                                                            data['nome'],
                                                            "Localização de ${data['nome']}",
                                                            "Vá até o endereço",
                                                            data[
                                                                'profissional']))
                                                  }
                                              });
                                    },
                                    child: const Text(
                                      'Aceitar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ))
                              ],
                            ),
                          );
                        })
                        .toList()
                        .cast(),
                  ),
                )
              ]);
            }

            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const SizedBox(
                    width: 240,
                    height: 8,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Image(image: AssetImage('images/aguardando.png')),
                  Text(
                    'Procurando Profissionais',
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                      width: 260,
                      child: Text(
                        textAlign: TextAlign.center,
                        'Estamos procurando profissionais perto de sua localização',
                        style: GoogleFonts.inter(
                            color: Colors.black38, fontSize: 16),
                      ))
                ]));
          }),
    );
  }
}

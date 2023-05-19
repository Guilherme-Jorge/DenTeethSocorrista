import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaAprovados extends StatefulWidget {
  const ListaAprovados({super.key, required this.title});

  final String title;

  @override
  State<ListaAprovados> createState() => _ListaAprovadosState();
}

class _ListaAprovadosState extends State<ListaAprovados> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('respostas')
      .where('status', isEqualTo: 'ACEITA')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          const Text('Texto aqui'),
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

                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Card(
                            child: ListTile(
                              tileColor: Colors.blueAccent,
                              textColor: Colors.white,
                              iconColor: Colors.redAccent,
                              title: Text(data['dataHora']),
                              trailing: IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Nome apagado')),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                            ),
                          );
                        })
                        .toList()
                        .cast(),
                  ),
                );
              }),
        ]));
  }
}

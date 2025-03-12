import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple_firebase1/auth/servei_auth.dart';
import 'package:exemple_firebase1/chat/Serveichat.dart';
import 'package:exemple_firebase1/componentes/bombolla_missatge.dart';
import 'package:flutter/material.dart';

class PaginaChat extends StatefulWidget {
  final String idReceptor;

  const PaginaChat({
    super.key,
    required this.idReceptor,
  });

  @override
  State<PaginaChat> createState() => _PaginaChatState();
}

class _PaginaChatState extends State<PaginaChat> {
  final TextEditingController tecMissatge = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      FerScrollAbajo();
    });
  }

  void FerScrollAbajo() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent + 100,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 231, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 153, 122),
        title: Text("Sala chat"),
      ),
      body: Column(
        children: [
          //zona missatges
          _crearzonamostrarmissatges(),

          //zona escribir missatges
          _crearzonamissatges(),
        ],
      ),
    );
  }

  Widget _crearzonamostrarmissatges() {
    return Expanded(
        child: StreamBuilder(
      stream: Serveichat()
          .getMissatges(ServeiAuth().getUsuariActual()!.uid, widget.idReceptor),
      builder: (context, snapshot) {
        //cas que hagi error
        if (snapshot.hasError) {
          return const Text("Error carregant missatges.");
        }

        //cas esta carregant dades
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("carregant missatges...");
        }

        //retornar dades (missatges)
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((document) => _construirItemMissatge(document))
              .toList(),
        );
      },
    ));
  }

  Widget _construirItemMissatge(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    return BombollaMissatge(
      missatge: data["missatge"],
      idAutor: data["idAutor"],
    );
  }

  Widget _crearzonamissatges() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: tecMissatge,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.green,
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: enviarMissatge,
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.green)),
          )
        ],
      ),
    );
  }

  void enviarMissatge() {
    if (tecMissatge.text.isNotEmpty) {
      Serveichat().enviarMissatge(widget.idReceptor, tecMissatge.text);
      tecMissatge.clear();

      Future.delayed(const Duration(milliseconds: 50), () {
      FerScrollAbajo();
    });
  }
 }
}
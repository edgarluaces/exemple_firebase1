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
  String _nombreReceptor = "Cargando..."; 

  FocusNode teclatMovil = FocusNode();

  @override
  void initState() {
    super.initState();

    // Llamamos a la función que obtiene el nombre del receptor
    _obtenerNombreReceptor();

    teclatMovil.addListener(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        FerScrollAbajo();
      });
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      FerScrollAbajo();
    });
  }

  Future<void> _obtenerNombreReceptor() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final receptorDoc = await firestore.collection("Usuarios").doc(widget.idReceptor).get();

      if (receptorDoc.exists) {
        final nombre = receptorDoc.data()?['nom'] ?? "";
        setState(() {
        _nombreReceptor = nombre.isNotEmpty ? nombre : receptorDoc.data()?['email'] ?? "Sala Chat";
      });
      }
    } catch (e) {
      print("Error al obtener el nombre del receptor: $e");
      setState(() {
        _nombreReceptor = "Sala Chat";
      });
    }
  }

  void FerScrollAbajo() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 231, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 153, 122),
        title: Text(_nombreReceptor), // El nombre o el valor por defecto
      ),
      body: Column(
        children: [
          _crearZonaMostrarMissatges(),
          _crearZonaMissatges(),
        ],
      ),
    );
  }

  Widget _crearZonaMostrarMissatges() {
    return Expanded(
      child: StreamBuilder(
        stream: Serveichat().getMissatges(
          ServeiAuth().getUsuariActual()!.uid,
          widget.idReceptor,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text("Error carregant missatges.");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Carregant missatges...");
          }

          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((document) => _construirItemMissatge(document))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _construirItemMissatge(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    final timestamp = data["timestamp"] as Timestamp?;
    final dataEnviament = timestamp?.toDate() ?? DateTime(2000, 1, 1); 

    return BombollaMissatge(
      missatge: data["missatge"]?.toString() ?? "",
      idAutor: data["idAutor"]?.toString() ?? "",
      dataEnviament: dataEnviament,
    );
  }

  Widget _crearZonaMissatges() {
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
            icon: Icon(Icons.send, color: Colors.white),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green),
            ),
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
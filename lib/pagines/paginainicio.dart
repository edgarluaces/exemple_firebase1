import 'package:exemple_firebase1/auth/servei_auth.dart';
import 'package:exemple_firebase1/chat/Serveichat.dart';
import 'package:exemple_firebase1/componentes/item_usuari.dart';
import 'package:flutter/material.dart';

class Paginainicio extends StatefulWidget {
  const Paginainicio({super.key});

  @override
  State<Paginainicio> createState() => _PaginainicioState();
}

class _PaginainicioState extends State<Paginainicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 147, 147),
        title: Text("Pagina Inicio"),
        actions: [
          IconButton(
            onPressed: () {
            ServeiAuth().ferLogout();
            }, 
          icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Serveichat().getUsuaris(), 
        builder: (context, snapshot) {
          
          //Mirar si hay error
          if(snapshot.hasError){
            return Text("ERROR en el Snapshot");
          }
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Text("Carregant dades...");
          }

          //Es retoran les dades

          return ListView(
            children: snapshot.data!.map<Widget>(
              (dadesUsuari) => _construeixItemUsuari(dadesUsuari)
            ).toList(),
          ); 
        }),
    );
  }
  Widget _construeixItemUsuari(Map<String, dynamic> dadesUsuari) {

    return ItemUsuari(emailUsuari: dadesUsuari["email"]);
  }
}
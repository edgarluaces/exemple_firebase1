import 'package:exemple_firebase1/chat/Serveichat.dart';
import 'package:flutter/material.dart';

class PaginaChat extends StatefulWidget {
  final String idReceptor;
  const PaginaChat({super.key,
  required this.idReceptor,
  });

  @override
  State<PaginaChat> createState() => _PaginaChatState();
}

class _PaginaChatState extends State<PaginaChat> {

  final TextEditingController tecMissatge = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Expanded(child: Text("1"));
  }

  
  Widget _crearzonamissatges() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(child: TextField(
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
            icon: Icon(Icons.send, color: Colors.white,),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll
              (Colors.green)),)
        ],
      ),
    );
  }

  void enviarMissatge(){

    if (tecMissatge.text.isNotEmpty){
      Serveichat().enviarMissatge(
        widget.idReceptor, 
        tecMissatge.text);
        tecMissatge.clear();
    }
  }

}
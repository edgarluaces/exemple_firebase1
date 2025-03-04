
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple_firebase1/models/missatge.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Serveichat {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsuaris(){

    return _firestore.collection("Usuarios").snapshots().map((event) {

      return event.docs.map((document) {

        return document.data();
        
      }).toList();
    });
  }

  Future<void> enviarMissatge(String idreceptor, String missatge) async{

    //la sala de chat es entre 2 usuaris

    String idUsuariActual = _auth.currentUser!.uid;
    String emailUsuariActual = _auth.currentUser!.email!;
    Timestamp timestamp = Timestamp.now();
    
    Missatge nouMissatge = Missatge(
      idAutor: idUsuariActual, 
      emailAutor: emailUsuariActual, 
      idReceptor: idUsuariActual, 
      missatge: missatge, 
      timestamp: timestamp);
    
    List<String> idsUsuaris = [idUsuariActual, idreceptor];
    idsUsuaris.sort(); //ordenem la llista

    String idSalachat = idsUsuaris.join("_");

    await 
    _firestore.collection("salesChat")
    .doc(idSalachat)
    .collection("Missatges").add(nouMissatge.retornaMapaMissatge(),
    );
  }
}
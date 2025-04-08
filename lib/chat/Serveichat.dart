import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple_firebase1/models/missatge.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Serveichat {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsuaris() {
    return _firestore.collection("Usuarios").snapshots().map((event) {
      return event.docs.map((document) {
        return document.data();
      }).toList();
    });
  }

  Future<void> enviarMissatge(String idReceptor, String missatge) async {
    String idUsuariActual = _auth.currentUser!.uid;
    String emailUsuariActual = _auth.currentUser!.email!;

    List<String> idsUsuaris = [idUsuariActual, idReceptor];
    idsUsuaris.sort();
    String idSalaChat = idsUsuaris.join("_");

    await _firestore
        .collection("salesChat")
        .doc(idSalaChat)
        .collection("Missatges")
        .add({
      "idAutor": idUsuariActual,
      "emailAutor": emailUsuariActual,
      "idReceptor": idReceptor, 
      "missatge": missatge,
      "timestamp": FieldValue.serverTimestamp(), 
    });
  }

  Stream<QuerySnapshot> getMissatges(String idUsuariActual, String idReceptor) {
    List<String> idsUsuaris = [idUsuariActual, idReceptor];
    idsUsuaris.sort();
    String idSalaChat = idsUsuaris.join("_");

    return _firestore
        .collection("salesChat")
        .doc(idSalaChat)
        .collection("Missatges")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}

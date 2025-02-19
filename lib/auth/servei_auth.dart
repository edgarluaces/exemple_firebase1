import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServeiAuth{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //fer registre
  Future<UserCredential> registroConEmailYPassword(String email, password) async {
    
    print("email:" + email);
    print("contraseña:" + password);

    try{

      UserCredential credencialUsuario = 
      await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,);

      _firestore.collection("Usuarios").doc(credencialUsuario.user!.uid).set({
        "uid" : credencialUsuario.user!.uid,
        "email": email,
        "nom" : "",
      });

    return credencialUsuario;


    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }

  }
}
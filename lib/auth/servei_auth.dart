import 'package:firebase_auth/firebase_auth.dart';

class ServeiAuth{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //fer registre
  Future<UserCredential> registroConEmailYPassword(String email, password) async {
    
    try{

      UserCredential credencialUsuario = await _auth.createUserWithEmailAndPassword(email: email, password: password,);

    return credencialUsuario;


    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }

  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServeiAuth{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  //Usuraio actual
  User? getUsuariActual(){

    return _auth.currentUser;
  }


  //fer logout
  Future<void> ferLogout()async{
    return await _auth.signOut();
  }
  

  //fer login
  Future<String?> loginconemailpassword(String email, String password)async{
    
    try{

      UserCredential credentialUsuari = await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password);

      //comprobem si l'usuari ja esta donat d'alta a Firestore 
      //(a firebaseAuth, si hem arribat aquí, ja sabem he si hi es).
      //si no estigués donat d'alta ek donem d'alta. Fet per si de cas
      //dones d'alta un usari dierectament

      final QuerySnapshot querySnapshot = 
      await _firestore
      .collection("Usuarios")
      .where("email", isEqualTo: email)
      .get();

      if (querySnapshot.docs.isEmpty) {
        
        _firestore.collection("Usuarios").doc(credentialUsuari.user!.uid).set({
        "uid" : credentialUsuari.user!.uid,
        "email": email,
        "nom" : "",
      });

      }

      

      return null;

    } on FirebaseAuthException catch(e){
      return "ERROR: ${e.message}";

    }
  }

  //fer registre
  Future<String?> registroConEmailYPassword(String email, password) async {
    
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

    return null;


    } on FirebaseAuthException catch (e) {
      
      switch(e.code){

        case "Email-already-in-use":
        return "Ya hay un usuario con este Gmail.";

        case "Invalid-email":
        return "Gmail no válido.";

        case "operation-not-allowed":
        return "Gmail/Password no habilitados.";

        case "Short-password":
        return "Contraseña molt curta";

        default:
        return "ERROR: ${e.message}";
      }
    } catch (e) {

      return "ERROR: $e";
    }

  }
}
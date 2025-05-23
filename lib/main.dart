import 'package:exemple_firebase1/auth/portal_auth.dart';
import 'package:exemple_firebase1/firebase_options.dart';
import 'package:exemple_firebase1/pagines/pagina_login.dart';
import 'package:exemple_firebase1/pagines/pagina_registre.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty){

    try{

    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
   }catch (e){
    print("error iniciant FIrebase");
   }

  }else{
    print("Error, Firebase ja esta inicialitzat");
  }
  


  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PortalAuth(),
    );
  }
}

/*
1) tenir Node.js instalat. FET
    cmd--     node -v
               npm -v

2) anar a firebase web i clicar Go to console

3) consola firebase crear projecte de firebase

4) anar al menu compilacion i habilitar:
      Authentification i Firestore Database

5) en una cmd, VS code fer: npm install -g firebase-tools (intalar firebase)

6) flutter pub global activate flutterfire-cli
    dart pub global activate flutterfire-cli

7) flutterfire configure

8) instalamos las dependencias de firebase
  -flutter pub add firebase_core
  -flutter pub add firebase_auth

*/
import 'package:exemple_firebase1/pagines/pagina_registre.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaginaRegistre(),
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

*/
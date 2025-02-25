import 'package:exemple_firebase1/auth/servei_auth.dart';
import 'package:flutter/material.dart';

class Paginainicio extends StatelessWidget {
  const Paginainicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: const Text("pagina inicio"),
    );
  }
}
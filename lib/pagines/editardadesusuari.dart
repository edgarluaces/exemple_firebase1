import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple_firebase1/auth/servei_auth.dart';
import 'package:exemple_firebase1/mongodb/db_conf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongodb;

class Editardadesusuari extends StatefulWidget {
  const Editardadesusuari({super.key});

  @override
  State<Editardadesusuari> createState() => _EditardadesusuariState();
}

class _EditardadesusuariState extends State<Editardadesusuari> {
  mongodb.Db? _db;
  Uint8List? _imageEnBytes;
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController _nomController = TextEditingController(); 
  String _emailUsuari = "";

  @override
  void dispose() {
    _nomController.dispose();
    _db?.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _conectarAmbMongoDB().then((_) {
      print("Conectado con MongoDB");
      _carregarDadesUsuari();
    });
  }

  Future _conectarAmbMongoDB() async {
    try {
      _db = await mongodb.Db.create(dbconf().connectstring);
      await _db!.open();
    } catch (e) {
      print("Error al conectar a MongoDB: $e");
    }
  }

  Future<void> _carregarDadesUsuari() async {
  final uid = ServeiAuth().getUsuariActual()?.uid;
  final email = ServeiAuth().getUsuariActual()?.email;

  if (uid != null) {
    try {
      _emailUsuari = email ?? "";
      final doc = await FirebaseFirestore.instance.collection("Usuarios").doc(uid).get();
      
      if (doc.exists && doc.data()!.containsKey("nom")) {
        _nomController.text = doc["nom"];
      } else {
        _nomController.text = "";
      }

      setState(() {});
    } catch (e) {
      print("Error carregant dades de Firestore: $e");
    }
  }
}

  Future<void> _guardarNom() async {
  if (_nomController.text.isNotEmpty) {
    try {
      final firestore = FirebaseFirestore.instance;
      final uid = ServeiAuth().getUsuariActual()!.uid;

      // Actualizamos el nombre 
      await firestore.collection("Usuarios").doc(uid).update({
        "nom": _nomController.text.trim(), 
      });

      Navigator.pop(context); // Volver atrás después de guardar
    } catch (e) {
      print("Error al guardar el nombre: $e");
    }
  } else {
    print("El nombre está vacío y no se puede guardar.");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Dades Usuari"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Edita les teves dades",
              style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(height: 20),
            Text(_emailUsuari, style: TextStyle(fontSize: 16)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  hintText: "Escriu el teu nom…",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _guardarNom,
              child: Text("Guardar"),
            ),
            SizedBox(height: 20),
            _imageEnBytes != null
                ? Image.memory(
                    _imageEnBytes!,
                    height: 200,
                  )
                : const Text("No s'ha seleccionat cap imatge"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _pujarImatge();
              },
              child: Text("Pujar imatge"),
            ),
            ElevatedButton(
              onPressed: () {
                _recuperarImatge();
              },
              child: Text("recuperar imatge"),
            ),
          ],
        ),
      ),
    );
  }

  Future _pujarImatge() async {
    final imatgeseleccionada = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imatgeseleccionada != null) {
      final bytesImatge = await File(imatgeseleccionada.path).readAsBytes();
      final dadesBinaries = mongodb.BsonBinary.from(bytesImatge);

      final collection = _db!.collection("Imatges_perfils");
      await collection.replaceOne(
        {"id_usuari_firebase": ServeiAuth().getUsuariActual()!.uid},
        {
          "id_usuari_firebase": ServeiAuth().getUsuariActual()!.uid,
          "nom_foto": "foto_perfil",
          "imatge": dadesBinaries,
          "data_pujada": DateTime.now()
        },
        upsert: true,
      );
      print("Imatge pujada");
    }
  }

  Future<void> _recuperarImatge() async {
    try {
      final collection = _db!.collection("Imatges_perfils");
      final doc = await collection.findOne({"id_usuari_firebase": ServeiAuth().getUsuariActual()!.uid});
      if (doc != null && doc["imatge"] != null) {
        final imatgeBson = doc["imatge"] as mongodb.BsonBinary;
        setState(() {
          _imageEnBytes = imatgeBson.byteList;
        });
      } else {
        print("Error trobant la imatge");
      }
    } catch (e) {
      print("Error intentant recuperar el document");
    }
  }
}
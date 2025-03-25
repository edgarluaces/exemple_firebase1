import 'dart:io';

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

  @override
  void dispose() {
    // TODO: implement initState
    _db?.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _conectarAmbMongoDB().then((_) => print("conectats amb MongoBD"));
  }

  Future _conectarAmbMongoDB() async {
    _db = await mongodb.Db.create(dbconf().connectstring);

    await _db!.open();
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
            Text("Edita les teves dades"),

            //afegim la imatge o un text
            _imageEnBytes != null
                ? Image.memory(
                    _imageEnBytes!,
                    height: 200,
                  )
                : const Text("No s'ha seleccionat cap imatge"),

              const SizedBox(height: 20,),

              ElevatedButton(onPressed: (){
                _pujarImatge();
              }, 
              child: Text("Pujar imatge"),),

              ElevatedButton(onPressed: () {
                _recuperarImatge();
              }, child: Text("recuperar imatge"),),
          ],
        ),
      ),
    );
  }

  Future _pujarImatge() async {
    final imatgeseleccionada =
        await imagePicker.pickImage(source: ImageSource.gallery);

    //mirem si ha trobat una imatge
    if (imatgeseleccionada != null) {
      //per guardar la imatge hem de passar a bytes
      final bytesImatge = await File(imatgeseleccionada.path).readAsBytes();
      // passem els bytes en format que Mongodb li va be
      final dadesBinaries = mongodb.BsonBinary.from(bytesImatge);

      final collection = _db!.collection("Imatges_perfils");

      await collection.replaceOne({
        "id_usuari_firebase": ServeiAuth().getUsuariActual()!.uid
      }, {
        "id_usuari_firebase": ServeiAuth().getUsuariActual()!.uid,
        "nom_foto": "foto_perfil",
        "imatge": dadesBinaries,
        "data_pujada": DateTime.now()
      },
          //fer que si no troba el document el crei
          upsert: true);
      print("imatge pujada");
    }
  }

  Future<void> _recuperarImatge() async {
    try {
      //ens connectem amb la collection
      final collection = _db!.collection("Imatges_perfils");

      //trobem el document buscat
      final doc = await collection
          .findOne({"id_usuari_firebase": ServeiAuth().getUsuariActual()!.uid});

      //podem recuperar imatge pero en format Bson
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

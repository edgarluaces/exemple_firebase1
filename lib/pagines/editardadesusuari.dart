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
  Uint8List? _imageEnByets;
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

  Future _conectarAmbMongoDB() async{

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
            Text("Edita les teves dades")
          ],
        ),
      ),
    );
  }
}
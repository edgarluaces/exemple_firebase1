import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongodb;
import 'package:exemple_firebase1/mongodb/db_conf.dart';

class ItemUsuari extends StatefulWidget {
  final String emailUsuari;
  final String idUsuari; 
  final Function()? onTap;

  const ItemUsuari({
    super.key,
    required this.emailUsuari,
    required this.idUsuari,
    required this.onTap,
  });

  @override
  State<ItemUsuari> createState() => _ItemUsuariState();
}

class _ItemUsuariState extends State<ItemUsuari> {
  Uint8List? _imatgeBytes;
  mongodb.Db? _db;

  @override
  void initState() {
    super.initState();
    _carregarImatgePerfil();
  }

  Future<void> _carregarImatgePerfil() async {
    try {
      _db = await mongodb.Db.create(dbconf().connectstring);
      await _db!.open();

      final collection = _db!.collection("Imatges_perfils");
      final doc = await collection.findOne({"id_usuari_firebase": widget.idUsuari});

      if (doc != null && doc["imatge"] != null) {
        final imatgeBson = doc["imatge"] as mongodb.BsonBinary;
        setState(() {
          _imatgeBytes = imatgeBson.byteList;
        });
      }

      await _db!.close();
    } catch (e) {
      print("Error carregant imatge de perfil: $e");
    }
  }

   @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 237, 137),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(top: 10, left: 40, right: 40),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
              ),
              child: _imatgeBytes != null
                  ? Image.memory(
                      _imatgeBytes!,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    )
                  : const Icon(Icons.person, size: 24, color: Color.fromARGB(137, 0, 0, 0)),
            ),
            const SizedBox(width: 12),
            Text(
              widget.emailUsuari,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

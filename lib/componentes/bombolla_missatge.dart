import 'package:exemple_firebase1/auth/servei_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BombollaMissatge extends StatelessWidget {
  final String idAutor;
  final String missatge;
  final DateTime dataEnviament;

  const BombollaMissatge({
    super.key,
    required this.missatge,
    required this.idAutor,
    required this.dataEnviament,
  });

  String formatarData() {
    final diferencia = DateTime.now().difference(dataEnviament).inDays;

    if (diferencia == 0) {
      return DateFormat('HH:mm ').format(dataEnviament);
    } else if (diferencia == 1) {
      return 'Fa 1 dia ';
    } else {
      return 'Fa $diferencia dies ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final esMeuMissatge = idAutor == ServeiAuth().getUsuariActual()!.uid;

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Align(
        alignment: esMeuMissatge ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: esMeuMissatge ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: esMeuMissatge ? Colors.green[400] : Colors.amber[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(missatge),
              ),
            ),
            const SizedBox(height: 3),
             Text(
              formatarData(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: esMeuMissatge ? Colors.green[800] : Colors.amber[800], 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
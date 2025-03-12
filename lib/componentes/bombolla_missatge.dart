import 'package:exemple_firebase1/auth/servei_auth.dart';
import 'package:flutter/material.dart';

class BombollaMissatge extends StatelessWidget {
  final String idAutor;
  final String missatge;

  const BombollaMissatge({
    super.key,
    required this.missatge,
    required this.idAutor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Align(
        alignment: idAutor == ServeiAuth().getUsuariActual()!.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
              color: idAutor == ServeiAuth().getUsuariActual()!.uid
                  ? Colors.green[400]
                  : Colors.amber[400],
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(missatge),
          ),
        ),
      ),
    );
  }
}

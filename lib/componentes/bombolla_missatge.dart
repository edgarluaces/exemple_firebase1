import 'package:flutter/material.dart';

class BombollaMissatge extends StatelessWidget {
  final String missatge;

  const BombollaMissatge({super.key,
  required this.missatge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Container(
        color: Colors.amber[200],
        child: Text(missatge),
      ),
    );
  }
}
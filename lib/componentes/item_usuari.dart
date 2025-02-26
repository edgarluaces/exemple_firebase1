import 'package:flutter/material.dart';

class ItemUsuari extends StatelessWidget {

  final String emailUsuari;

  const ItemUsuari({super.key,
  required this.emailUsuari,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color.fromARGB(255, 248, 237, 137),
      borderRadius: BorderRadius.circular(10),
      ),
      margin:  EdgeInsets.only(top: 10, left: 40, right: 40),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(emailUsuari),
      ));
  }
}
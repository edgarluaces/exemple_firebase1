import 'package:flutter/material.dart';

class TextfieldAuth extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;


  const TextfieldAuth({super.key,
  required this.controller,
  required this.obscureText,
  required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: TextField(
        cursorColor: Color.fromARGB(255, 250, 14, 112),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        controller: controller,                     //<--- variable
        obscureText: obscureText,                   //<--- variable 
        decoration: InputDecoration(
          hintText: hintText,                       //<--- variable 
          hintStyle: TextStyle(color: Colors.orange[800]),
          
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 250, 14, 112),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color.fromARGB(255, 47, 0, 255)),
          ),
          fillColor: const Color.fromARGB(255, 241, 233, 208),
          filled: true,
        ),
      ),
      
    );
  }
}
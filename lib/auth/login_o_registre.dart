import 'package:exemple_firebase1/pagines/pagina_login.dart';
import 'package:exemple_firebase1/pagines/pagina_registre.dart';
import 'package:flutter/material.dart';

class LoginORegistre extends StatefulWidget {
  const LoginORegistre({super.key});

  @override
  State<LoginORegistre> createState() => _LoginORegistreState();
}

class _LoginORegistreState extends State<LoginORegistre> {

  bool mostrapaginalogin = true;

  void intercambiarpaginesloginregistre(){
    setState(() {
      
    mostrapaginalogin = !mostrapaginalogin;
     });
  }

  @override
  Widget build(BuildContext context) {
    
    if(mostrapaginalogin){
      return PaginaLogin(ferclic: intercambiarpaginesloginregistre,);
    }else{
      return PaginaRegistre(ferclic: intercambiarpaginesloginregistre,);
    }

  }
}
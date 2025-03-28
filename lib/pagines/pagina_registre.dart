import 'package:exemple_firebase1/auth/servei_auth.dart';
import 'package:exemple_firebase1/componentes/boto_auth.dart';
import 'package:exemple_firebase1/componentes/textfield_auth.dart';
import 'package:flutter/material.dart';

class PaginaRegistre extends StatelessWidget {

  final Function()? ferclic;

  const PaginaRegistre({super.key,
  required this.ferclic,
  });


  void ferRegistre(BuildContext context, String email, String password, String confPassword ) async{

    if(password.isEmpty || email.isEmpty) {
      //Gestionarlo
      return;
    }

    if(password != confPassword){
      //Gestionar
      return;
    }

    String? error = await ServeiAuth().registroConEmailYPassword(email, password);

    if (error != null){
        showDialog(context: context, builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 238, 138, 131),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text("Error"),
        content: Text(email),
      )
     );
    }
  }

  @override
  Widget build(BuildContext context) {

    final TextEditingController tecEmail = TextEditingController();
    final TextEditingController tecPassword = TextEditingController();
    final TextEditingController tecConfPass = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 230, 156),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
            
                //logo
                Icon(Icons.fireplace, size: 120, color: const Color.fromARGB(255, 250, 14, 112),),
          
                SizedBox(height: 25,),
            
                //frase
                Text("Crea un compte nou!", 
                  style: TextStyle(
                  color: Color.fromARGB(255, 250, 14, 112), 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold),),
            
                  SizedBox(height: 25,),
          
                //text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(
                        thickness: 1,
                        color: Color.fromARGB(255, 250, 14, 112),)),
          
                //text divisori
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text("Registra't", style: TextStyle(color: Color.fromARGB(255, 250, 14, 112),),),
                      ),
                  
                       Expanded(child: Divider(
                        thickness: 1,
                        color: Color.fromARGB(255, 250, 14, 112),)),
                    ],
                  ),
                ),
            
                //textfield email
                TextfieldAuth(
                  controller: tecEmail,
                  hintText: "Esriu el teu Email",
                  obscureText: false,
                ),
            
                //textfield password
                TextfieldAuth(
                  controller: tecPassword,
                  hintText: "Escriu el password",
                  obscureText: true,
                ),
            
            
                //textfield confpasword
                TextfieldAuth(
                  controller: tecConfPass,
                  hintText: "Repeteix la password",
                  obscureText: true,
                ),
          
                SizedBox(height: 10,),
            
                //No estas registrat
                Padding(
                  padding: const EdgeInsets.only(right: 140),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Ja ets membre?", 
                        style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: Color.fromARGB(255, 255, 0, 0),),),
                  
                      SizedBox(width: 5,),
                  
                      GestureDetector(
                        onTap: ferclic,
                        child: Text("Fes login", 
                          style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: Color.fromARGB(255, 11, 109, 28),),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),

                //boton registro
                BotoAuth(
                  text: "Registre",
                  onTap: () => ferRegistre(context, tecEmail.text, tecPassword.text, tecConfPass.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
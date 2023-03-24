import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_pet/utils/dimensions.dart';
import 'package:social_pet/utils/utils.dart';
import 'package:social_pet/widget/text_file_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    String res = "Ha ocurrido algun error o no tiene conexion a internet";
    try {
      if (_emailController.toString().isNotEmpty) {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text);
        res = 'Comprueba tu bandeja de corre electronico';
        showSnackBar(res, context);
      } else {
        res = 'No deje espacios vacios';
        showSnackBar(res, context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'unknown') {
        res = 'El correo no puede estar vacio';
        showSnackBar(res, context);
      } else if (e.code == 'invalid-email') {
        res = 'El formato de email no es correcto';
        showSnackBar(res, context);
      } else if (e.code == 'user-not-found') {
        res = 'El email no se encuentra';
        showSnackBar(res, context);
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo1.png',
            height: 64,
          ),
          //Texto email
          const SizedBox(
            height: 20,
          ),
          TextFieldInput(
              textEditingController: _emailController,
              hintText: 'Introduce tu email',
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
              onPressed: passwordReset,
              child: Text('Restablecer contraseña'),
              color: Colors.deepOrangeAccent),
        ],
      ),
    );
  }
}

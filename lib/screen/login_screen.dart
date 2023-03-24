import 'package:flutter/material.dart';
import 'package:social_pet/reponsive/mobile_screen.dart';
import 'package:social_pet/reponsive/reponsive_screen.dart';
import 'package:social_pet/resources/auth_method.dart';
import 'package:social_pet/screen/forgot_pwd.dart';
import 'package:social_pet/screen/home_Screen.dart';
import 'package:social_pet/reponsive/web_screen.dart';
import 'package:social_pet/screen/signup.dart';
import 'package:social_pet/utils/colors.dart';
import 'package:social_pet/utils/dimensions.dart';
import 'package:social_pet/utils/utils.dart';

import 'package:social_pet/widget/text_file_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'El usuario se ha logueado corectamente') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const ReponsiveLayout(
                  mobileScreenLayout: MobileScreen(),
                  webScreenLayout: WebScreen(),
                )),
      );
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              //svg foto
              Image.asset(
                'assets/logo1.png',
                height: 64,
              ),
              //Texto email
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Introduce tu email',
                  textInputType: TextInputType.emailAddress),
              //Texto password
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Introduce tu contraseña',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              //boton login
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ForgotPasswordPage();
                        }));
                      },
                      child: Text(
                        "¿Has olvidado la contraseña?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text("Iniciar sesión"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: Colors.deepOrangeAccent),
                ),
              ),
              //Transincio a registrarse
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Si no tienes cuenta?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      child: const Text(
                        "Registrarse",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

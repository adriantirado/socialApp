import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:social_pet/providers/user_provider.dart';
import 'package:social_pet/reponsive/mobile_screen.dart';
import 'package:social_pet/reponsive/reponsive_screen.dart';
import 'package:social_pet/reponsive/web_screen.dart';
import 'package:social_pet/resources/auth_method.dart';
import 'package:social_pet/models/user.dart' as model;
import 'package:social_pet/utils/colors.dart';
import 'package:social_pet/utils/utils.dart';
import 'package:social_pet/widget/text_file_input.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordconfirmController =
      TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  var db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    _passwordconfirmController.dispose();
  }

  //Metodo que abre la galeria
  void selectImageGallery() async {
    await Permission.photos.request();
    var permission = await Permission.photos.status;

    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  //Metodo que abre la camara
  void selectImageCamera() async {
    Uint8List im = await pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  void singUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res1 = "No has seleccionado ninguna imagen";
    if (_image == null) {
      showSnackBar(res1, context);
    }
    String password = "No deje espacios en blanco";
    if (_passwordconfirmController.text.isEmpty) {
      showSnackBar(password, context);
    } else {
      String errorpas = "Las contraseñas no coinciden";
      if (_passwordController.text != _passwordconfirmController.text) {
        showSnackBar(errorpas, context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    String user = "EL nombre de usuario ya existe";
    print(snap.data());
    if (_usernameController.text == snap.data()) {
      showSnackBar(user, context);
    }
    setState(() {
      _isLoading = false;
    });
    //controlar username si esta vacio o no
    String userna = "No deje espacios en blancos";
    if (_usernameController.text.isEmpty || _bioController.text.isEmpty) {
      showSnackBar(userna, context);
    }
    setState(() {
      _isLoading = false;
    });

    String res = await AuthMethods().singUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      confirmpassowrd: _passwordconfirmController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });

    if (res != "Usuario registrado correctamente") {
      showSnackBar(res, context);
    } else {
      if (_passwordController.text == _passwordconfirmController.text) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ReponsiveLayout(
              mobileScreenLayout: LoginScreen(),
              webScreenLayout: WebScreen(),
            ),
          ),
        );
      } else {
        String errorpas2 = "Las contraseñas no coinciden";
        showSnackBar(errorpas2, context);
      }
    }
  }

  //Metodo que saca un dialogo con dos opciones
  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Opciones"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Camara"),
                    onTap: () {
                      selectImageCamera();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      selectImageGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
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
              const SizedBox(height: 64),
              //Imagen de pefil
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2017/09/25/13/12/puppy-2785074_1280.jpg'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                        showOptionsDialog(context);
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              //Texto username
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Introduce tu nombre de usuario',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              //Texto email

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

              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _passwordconfirmController,
                hintText: 'Confirmar contraseña',
                textInputType: TextInputType.text,
                isPass: true,
              ),

              const SizedBox(
                height: 24,
              ),
              //Texto bio
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Introduce tu biografia',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              //boton login
              InkWell(
                onTap: singUpUser,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : const Text("Registrarse"),
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
                    child: const Text("Si tiene cuenta? "),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: const Text(
                        "Iniciar sesión",
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

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_pet/models/user.dart' as model;
import 'package:social_pet/resources/storage_method.dart';
import 'package:social_pet/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //Registrar usuario
  Future<String> singUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Ha ocurrido algun error o no tiene conexion a internet";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //Vanos a registrar usuario
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await Storage_Method()
            .uploadImageToStorage('profilePics', file, false);

        //añadir usuario

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = "Usuario registrado correctamente";
      } else {
        res = "No dejes campos vacios";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'unknown') {
        res = 'El correo y la contraseña no pueden estar vacio';
      } else if (err.code == 'invalid-email') {
        res = 'El formato de email no es correcto';
      } else if (err.code == 'email-already-in-use') {
        res = 'El email ya esta en uso';
      } else if (err.code == 'weak-password') {
        res = 'La contraseña no cumple con los requisitos';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

//logear usuario
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Ha ocurrido algun error';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'El usuario se ha logueado corectamente';
      } else {
        res = 'No dejes campos vacios';
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        res = 'El formato de email no es correcto';
      } else if (error.code == 'wrong-password') {
        res = 'La contraseña no es correcta';
      } else if (error.code == 'network-request-failed') {
        res = 'No tienes conexion a internet';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

 
}

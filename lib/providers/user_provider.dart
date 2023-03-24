import 'package:flutter/material.dart';
import 'package:social_pet/models/user.dart';
import 'package:social_pet/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethod = AuthMethods();
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

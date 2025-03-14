import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/auth/storage.dart';
import 'package:instagram/data/firebase_services/firestor.dart';
import 'package:instagram/utils/exception.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN
  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (e) {
      throw Exceptions(e.message.toString());
    }
  }

  // SIGN UP
  Future<void> signUp({
    required String email,
    required String password,
    required String passwordcomfirm,
    required String username,
    required String bio,
    required File profile,
  }) async {
    String URL;
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        if (password == passwordcomfirm) {
          // create user with email and password
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());
          print('Khoi tao thanh cong');
          // Upload profile image on storage
          print(profile.path);
          if (profile.path != '') {
            URL =
                await StorageMethod().uploadImageToStorage('Profile', profile);
            print('done URL');
          } else {
            URL = "";
          }
          // get information with firestore
          await FirebaseFirestor().createUser(
              email: email,
              username: username,
              bio: bio,
              profile: URL == ''
                  ? 'https://vcdn1-dulich.vnecdn.net/2021/07/16/1-1626437591.jpg?w=460&h=0&q=100&dpr=2&fit=crop&s=i2M2IgCcw574LT-bXFY92g'
                  : URL);
        } else {
          throw Exceptions('password and comfirm password should be same');
        }
      } else {
        throw Exceptions('Enter all the fields');
      }
    } on FirebaseException catch (e) {
      throw Exceptions(e.message.toString());
    }
  }
}

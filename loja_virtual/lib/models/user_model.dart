import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  Future<void> signUp(
      {@required Map<String, dynamic> userData,
      @required String passWord,
      @required VoidCallback onSucces,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"], password: passWord);

    if (_auth.currentUser != null) {
      firebaseUser = _auth.currentUser;
      await _saveUserData(userData);
      onSucces();
      isLoading = false;
      notifyListeners();
    } else {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));

    isLoading = false;
    notifyListeners();
  }

  void recoverPass() {}

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .set(userData);
  }
}

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

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  Future<void> signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSucces,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"], password: password);

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

  void signIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: password);

    if (_auth.currentUser != null) {
      firebaseUser = _auth.currentUser;
      await _loadCurrentUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    } else {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .set(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .get();

        userData = docUser.data();
      }
    }
    notifyListeners();
  }
}

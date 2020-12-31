import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  
  Future<void> signIn(String email, String password) async {
    UserCredential userC = await auth.signInWithEmailAndPassword(email: email, password: password);
    user = userC.user;
  } 

  Future<void> signUp(String email, String password) async {
    UserCredential userC = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    user = userC.user;
  }

  User getCurrentUser() {
    return user;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> sendEmailVerification() async {
    await user.sendEmailVerification();
  }

  bool isVerified() {
    return user.emailVerified;
  }

  Future<void> changeEmail(String email) async {
    user.updateEmail(email);
  }

  Future<void> changePassword(String password) async {
    await user.updatePassword(password);
  }

  Future<void> deleteUser() async {
    await user.delete();
  }

  Future<void> sendPasswordResetMail(String email) async{
    await auth.sendPasswordResetEmail(email: email);
  }
}
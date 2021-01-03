import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChanged => auth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  } 

  Future<void> signUp(String email, String password) async {
    await auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> updateEmail(String email) async {
    await auth.currentUser.updateEmail(email);
  }

  Future<void> updatePassword(String password) async {
    await auth.currentUser.updatePassword(password);
  }

  Future<void> updateProfile({String displayName, String photoURL}) async {
    await auth.currentUser.updateProfile(displayName: displayName, photoURL: photoURL);
  }

  Future<void> sendPasswordResetMail(String email) async{
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    await auth.currentUser.sendEmailVerification();
  }

  Future<void> deleteUser() async {
    await auth.currentUser.delete();
  }

  bool isVerified() {
    return auth.currentUser.emailVerified;
  }
}
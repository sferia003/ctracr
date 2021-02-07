import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCT> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    return UserCT.fromSnapshot(
        await firestore.collection("users").doc(auth.currentUser.uid).get());
  }

  Future<void> signUp(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCT> signUpVerification(bool isOrganizer, String firstName) async {
    await auth.currentUser.reload();
    if (!isVerified()) throw NotVerifiedException();
    UserCT user;
    user = new UserCT(
        isOrganizer, firstName, auth.currentUser.email, false, false);
    await firestore
        .collection("users")
        .doc(auth.currentUser.uid)
        .set(user.toJson());
    return user;
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
    await auth.currentUser
        .updateProfile(displayName: displayName, photoURL: photoURL);
  }

  Future<void> sendPasswordResetMail(String email) async {
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

class NotVerifiedException implements Exception {
  NotVerifiedException();
}

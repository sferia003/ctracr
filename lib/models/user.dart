import 'package:firebase_database/firebase_database.dart';

class User {
  String id, username, email, password;

  User(this.id, this.username, this.email, this.password);

  User.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value["id"],
        username = snapshot.value["username"],
        email = snapshot.value["email"],
        password = snapshot.value["password"];

  toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "password": password
    };

  }
}

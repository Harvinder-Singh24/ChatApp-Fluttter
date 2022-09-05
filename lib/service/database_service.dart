import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSevice {
  final String? uid;
  DatabaseSevice({this.uid});

  //refrence to the collections
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection("groups");

  //saving  the value to the database
  Future updateUserData(String fullname, String email) async {
    return await usersCollection.doc(uid).set({
      "fullName": fullname,
      "email": email,
      "groups": [],
      "Profilepic": "",
      "uid": uid,
    });
  }

  //retrieving the value from the database
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await usersCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}

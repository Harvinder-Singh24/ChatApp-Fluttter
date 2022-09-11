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

  //getting the user group data
  Future getuserGroupData() async {
    return usersCollection.doc(uid).snapshots();
  }

  //saving the value of groups
  Future updategroupData(String groupName, String id, String userName) async {
    DocumentReference groupdocumentReference = await groupsCollection.add({
      "groupname": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    await groupdocumentReference.update({
      "members": FieldValue.arrayUnion(["${id}_$userName"])
    });

    DocumentReference userDocumentReference = usersCollection.doc(id);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });
  }
}

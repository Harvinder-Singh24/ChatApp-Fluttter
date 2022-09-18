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
      "members": FieldValue.arrayUnion(["${id}_$userName"]),
      "groupId": groupdocumentReference.id,
    });

    DocumentReference userDocumentReference = usersCollection.doc(id);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });
  }

  //getting the chat
  getChats(String groupdId) async {
    return groupsCollection
        .doc(groupdId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  //getting the agrou admin name
  Future getGroupAdmin(String groupid) async {
    DocumentReference d = groupsCollection.doc(groupid);
    DocumentSnapshot documentsnapshot = await d.get();
    return documentsnapshot["admin"];
  }

  //getting all the members of the group
  getMembers(groupId) async {
    return groupsCollection.doc(groupId).snapshots();
  }

  //search
  searchUser(String groupName) {
    return groupsCollection.where("groupname", isEqualTo: groupName).get();
  }

  //user has joined the group or not
  Future<bool> didUserJoinedGroup(
      String groupName, String groupId, String userName) async {
    DocumentReference documentReference = usersCollection.doc(uid);
    DocumentSnapshot documentsnapshot = await documentReference.get();

    List<dynamic> groups = await documentsnapshot['groups'];
    if (groups.contains("${groupId}_${groupName}")) {
      return true;
    } else {
      return false;
    }
  }

  //toggle for the join or not join button groups
  Future toogleGroupJoin(
      String groupId, String userName, String groupName) async {
    print("Group Id for this group in Databse  ${groupId}");
    DocumentReference userDocumentReference = usersCollection.doc(uid);
    DocumentReference groupdocumentReference = groupsCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupdocumentReference.update({
        "members": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupdocumentReference.update({
        "members": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
    }
  }

  //send the message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupsCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupsCollection.doc(groupId).update({
      "recentMessage": chatMessageData["message"],
      "recentMessageSender": chatMessageData["sender"],
      "recentMessageTime": chatMessageData["time"].toString(),
    });
  }
}

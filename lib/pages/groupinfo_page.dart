import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/texfield_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class GroupInfo extends StatefulWidget {
  String groupName;
  String groupId;
  String adminName;
  GroupInfo(
      {Key? key,
      required this.groupName,
      required this.groupId,
      required this.adminName})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  String getUserName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  String getGroupId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  Stream? members;

  fetchMemberName() async {
    DatabaseSevice(uid: FirebaseAuth.instance.currentUser!.uid)
        .getMembers(widget.groupId)
        .then((value) => {
              print("Group Id inside group info ${widget.groupId}"),
              setState(() {
                members = value;
              }),
              print("Members  inside group info ${members}"),
            });
  }

  @override
  void initState() {
    fetchMemberName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Group Info"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content: const Text(
                            "Are you sure you want to exit the group?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () async {
                              DatabaseSevice(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .toogleGroupJoin(
                                      widget.groupId,
                                      getUserName(widget.adminName),
                                      widget.groupName)
                                  .whenComplete(
                                      () => {nextScreen(context, HomPage())});
                            },
                            icon: const Icon(Icons.check, color: Colors.green),
                          )
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  //icon
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text(
                          "Group:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(widget.groupName)
                      ]),
                      const SizedBox(height: 3),
                      Row(children: [
                        const Text(
                          "Admin:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(getUserName(widget.adminName))
                      ])
                    ],
                  )
                ],
              ),
            ),
            groupMemberList(),
          ],
        ),
      ),
    );
  }

  groupMemberList() {
    return StreamBuilder(
      stream: members,
      builder: ((context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                              getUserName(snapshot.data['members'][index])
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        title:
                            Text(getUserName(snapshot.data["members"][index])),
                        subtitle:
                            Text(getGroupId(snapshot.data["members"][index])),
                      ),
                    );
                  });
            } else {
              return const Center(child: Text("No Members"));
            }
          } else {
            return const Center(child: Text("No Members"));
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
        }
      }),
    );
  }
}

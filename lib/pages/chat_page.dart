import 'package:chatapp/pages/groupinfo_page.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/texfield_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  String groupId;
  String groupName;
  String userName;
  ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseSevice().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    DatabaseSevice().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
      print("Admin value inside chat page ${admin}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "${widget.groupName}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                  onTap: () {
                    nextScreen(
                        context,
                        GroupInfo(
                            groupName: widget.groupName,
                            groupId: widget.groupId,
                            adminName: admin));
                  },
                  child: const Icon(Icons.info, size: 30)),
            ),
          ],
        ),
        body: const Center(child: Text("Chat Screen")));
  }
}

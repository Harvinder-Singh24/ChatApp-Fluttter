import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/texfield_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;

  @override
  void initState() {
    fetchUserNameandId();
    super.initState();
  }

  fetchUserNameandId() async {
    await HelperFunction.getUserName().then((value) => {
          setState(() {
            userName = value!;
          })
        });
    user = FirebaseAuth.instance.currentUser;
  }

  String getUserName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  String getGroupId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Seach Groups...",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initializeSearch();
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(40)),
                        child: const Icon(Icons.search, color: Colors.white)),
                  )
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor))
                : groupList(),
          ],
        ),
      ),
    );
  }

  initializeSearch() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      DatabaseSevice().searchUser(searchController.text).then((value) {
        setState(() {
          searchSnapshot = value;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupname'],
                searchSnapshot!.docs[index]['admin'],
              );
            })
        : Container();
  }

  joinedOrNot(String userName, String groupId, String groupName) async {
    await DatabaseSevice(uid: FirebaseAuth.instance.currentUser!.uid)
        .didUserJoinedGroup(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = true;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    //check whether the user has joined the group or not
    joinedOrNot(userName, groupId, groupName);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text("Admin: ${getUserName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          print("Group Id in Search Page ${groupId}");
          await DatabaseSevice(uid: user!.uid)
              .toogleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            print("Value of Joined variable ${isJoined}");
            showSnackBar(context, Colors.green, "Sucessfully joined the group");
            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                      groupId: groupId,
                      groupName: groupName,
                      userName: userName));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
              showSnackBar(context, Colors.red, "Suceesfully left the group");
            });
          }
        },
        child: isJoined
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  "Join Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}

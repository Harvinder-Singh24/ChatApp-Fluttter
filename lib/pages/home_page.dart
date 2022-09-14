import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/profile_page.dart';
import 'package:chatapp/pages/search_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/groupcard.dart';
import 'package:chatapp/widgets/texfield_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomPage extends StatefulWidget {
  HomPage({Key? key}) : super(key: key);

  @override
  State<HomPage> createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  String? email = '';
  String? name = '';
  AuthService authService = AuthService();
  Stream? groups;
  String? userGroupName;
  bool isLoading = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  String getGroupId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String getUserName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  getUserData() async {
    await HelperFunction.getUserEmail().then((value) => {
          setState(() {
            email = value;
          })
        });
    await HelperFunction.getUserName().then((value) => {
          setState(() {
            name = value;
          })
        });

    await DatabaseSevice(uid: FirebaseAuth.instance.currentUser!.uid)
        .getuserGroupData()
        .then((value) => {
              setState(() {
                groups = value;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => groupaddbutton(context),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          child: const Icon(Icons.add),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              const Icon(
                Icons.account_circle,
                size: 150,
              ),
              Text(
                name.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                height: 2,
              ),
              ListTile(
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                leading: const Icon(Icons.group),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: const Text(
                  "Groups",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {
                  nextScreenReplacement(context, ProfilePage());
                },
                selectedColor: Theme.of(context).primaryColor,
                leading: const Icon(Icons.account_box_sharp),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content: const Text("Are you sure you want to exit?"),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.cancel, color: Colors.red),
                            ),
                            IconButton(
                              onPressed: () async {
                                await authService.signout();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false);
                              },
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                            )
                          ],
                        );
                      });
                },
                selectedColor: Theme.of(context).primaryColor,
                leading: const Icon(Icons.exit_to_app),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: IconButton(
                onPressed: () => nextScreen(context, SearchPage()),
                icon: const Icon(
                  Icons.search,
                  size: 27,
                  color: Colors.white,
                ),
              ),
            )
          ],
          title: const Text("We Chat",
              style: TextStyle(
                  fontSize: 27,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
        body: groupList());
  }

  groupaddbutton(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, builder) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                            onChanged: (val) {
                              setState(() {
                                userGroupName = val;
                              });
                            },
                            decoration: textfieldDecoration)
                      ],
                    ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    if (userGroupName != null) {
                      setState(() {
                        isLoading = true;
                      });
                      DatabaseSevice(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .updategroupData(
                              userGroupName.toString(),
                              FirebaseAuth.instance.currentUser!.uid,
                              name.toString())
                          .whenComplete(() => {
                                setState(() {
                                  isLoading = false;
                                })
                              });
                      Navigator.of(context).pop();
                      showSnackBar(context, Colors.green, "Group Created");
                    } else {}
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            );
          });
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data["groups"].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupCard(
                        groupId:
                            getGroupId(snapshot.data["groups"][reverseIndex]),
                        groupName:
                            getUserName(snapshot.data["groups"][reverseIndex]),
                        userName: name.toString());
                  });
            } else {
              return missingGroupWidget();
            }
          } else {
            return missingGroupWidget();
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
        }
      },
    );
  }

  missingGroupWidget() {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                groupaddbutton(context);
              },
              child: const Icon(
                Icons.add,
                color: Colors.grey,
                size: 150,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Join or Create a group",
                style: TextStyle(color: Colors.grey, fontSize: 18))
          ],
        ),
      ),
    );
  }
}

import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/widgets/texfield_decoration.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    getUserData();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onTap: () {
                  nextScreen(context, HomPage());
                },
                selectedColor: Theme.of(context).primaryColor,
                leading: const Icon(Icons.group),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: const Text(
                  "Groups",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
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
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
            child: Column(
              children: [],
            )));
  }
}

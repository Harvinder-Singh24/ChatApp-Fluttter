import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/profile_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/widgets/texfield_decoration.dart';
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
  @override
  void initState() {
    getUserData();
    super.initState();
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
                            icon: const Icon(Icons.check, color: Colors.green),
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
        actions: const [
          Icon(
            Icons.search,
            color: Colors.white,
            size: 27,
          )
        ],
        title: const Text("We Chat",
            style: TextStyle(
                fontSize: 27,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authService.signout();
          },
          child: const Text("Log Out"),
        ),
      ),
    );
  }
}

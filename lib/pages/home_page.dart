import 'package:chatapp/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomPage extends StatefulWidget {
  HomPage({Key? key}) : super(key: key);

  @override
  State<HomPage> createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("We Chat",
            style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                authService.signout();
              },
              child: const Text("Log Out"))),
    );
  }
}

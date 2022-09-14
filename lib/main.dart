import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constant.apiKey,
            appId: Constant.appId,
            messagingSenderId: Constant.messaginSenderId,
            projectId: Constant.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  bool isSignedIn = false;

  @override
  void initState() {
    UserLoggedInStatus();
    super.initState();
  }

  UserLoggedInStatus() async {
    await HelperFunction.getUserLoggedIn().then((value) => {
          if (value != null)
            {
              setState(() {
                isSignedIn = value;
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
        primaryColor: Constant().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: isSignedIn ? HomPage() : LoginPage(),
    );
  }
}

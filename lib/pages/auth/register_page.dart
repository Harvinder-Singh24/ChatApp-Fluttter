import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/helper_function.dart';
import '../../widgets/texfield_decoration.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  String email = "";
  String password = "";
  String name = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 50),
                      child: Column(
                        children: [
                          Text("WeChat",
                              style: TextStyle(
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontSize: 45,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Create an account to start chatting",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200)),
                          Image.asset("assets/register.png"),
                          TextFormField(
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            },
                            decoration: textfieldDecoration.copyWith(
                              hintText: "Full Name",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            validator: (val) {
                              if (val != null) {
                                return null;
                              } else {
                                return "Name cannot be null";
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            decoration: textfieldDecoration.copyWith(
                              hintText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                            obscureText: false,
                            decoration: textfieldDecoration.copyWith(
                                hintText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                )),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                register();
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Login here",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, LoginPage());
                                      }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  register() {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authService
          .registerUserWithEmailAndPassword(name, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunction.setUserLoggedIn(true);
          await HelperFunction.setUserNameSP(name);
          await HelperFunction.setUserEmailSP(email);
          nextScreenReplacement(context, HomPage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}

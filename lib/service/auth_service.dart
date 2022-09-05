import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebase_auth = FirebaseAuth.instance;

  //login
  Future LoginUserWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebase_auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  //register
  Future registerUserWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      User user = (await firebase_auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        //add the user data to the storage
        await DatabaseSevice(
          uid: user.uid,
        ).updateUserData(name, email);

        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  //signout
  Future signout() async {
    await HelperFunction.setUserLoggedIn(false);
    await HelperFunction.setUserEmailSP("");
    await HelperFunction.setUserNameSP("");
    firebase_auth.signOut();
  }
}

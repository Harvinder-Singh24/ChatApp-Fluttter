import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userLoggedInKey = "LOGGEDINKey";
  static String useremailkey = "EMAILKEY";
  static String usernameKey = "NAMEKEY";

  //sending the data to SP
  static Future<bool> setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences shared_preferences =
        await SharedPreferences.getInstance();
    return await shared_preferences.setBool(userLoggedInKey, isLoggedIn);
  }

  static Future<bool> setUserNameSP(String name) async {
    SharedPreferences shared_preferences =
        await SharedPreferences.getInstance();
    return await shared_preferences.setString(usernameKey, name);
  }

  static Future<bool> setUserEmailSP(String email) async {
    SharedPreferences shared_preferences =
        await SharedPreferences.getInstance();
    return await shared_preferences.setString(useremailkey, email);
  }

  //getting the data to SP
  static Future<bool?> getUserLoggedIn() async {
    SharedPreferences shared_preferences =
        await SharedPreferences.getInstance();
    return shared_preferences.getBool(userLoggedInKey);
  }
}

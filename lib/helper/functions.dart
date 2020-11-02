import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String UserLoggedInKey = "USERLOGGEDINKEY";
  static String UserLoggedInID = "";
  
  static saveUserLoggedInDetails({@required bool isLoggedIn, String userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(UserLoggedInKey, isLoggedIn);
    prefs.setString(UserLoggedInID, userId);
  }

  static Future<bool> getUserLoggedInDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UserLoggedInKey);
  }

  static Future<String> getUserLoggedInID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(UserLoggedInID);
  }
}

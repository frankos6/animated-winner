import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/DTO/UserLoginDTO.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/services/Config.dart';

class UserService{
  UserService();
  static late User user;
  static bool loggedIn = false;
  static bool registered = false;
  static String loginData = "";


  Future<void> getUserData(UserLoginDTO userData) async {
    ///request user data from api
    try {
      String credentials = "${userData.login}:${userData.password}";
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(credentials);
      encoded = "Basic $encoded";

      var response = await http.get(
          Uri.parse('${Config.ip}/auth'),
          headers: {"Authorization": "$encoded"}
      );

      if(response.statusCode == 200){
        user = User.fromJson(jsonDecode(response.body));
        loginData = encoded;
        loggedIn = true;
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> registerUser(UserLoginDTO userData) async {
    try {
      var response = await http.post(
          Uri.parse('${Config.ip}/user/register'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userData.toMap())
      );
      registered = true;
    } catch(e) {
      print(e);
    }
  }

  void logOut() {
    loggedIn = false;
    registered = false;
    user = User(userId: 0, login: "", isAdmin: false, created: "");
    loginData = "";
  }

  Future<void> changeUserRole(int userId, bool admin) async {
    try {
      var response = await http.put(
          Uri.parse('${Config.ip}/user/$userId/admin'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": UserService.loginData
          },
          body: admin.toString()
      );

    } catch(e) {
      print(e);
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/DTO/UserLoginDTO.dart';
import 'package:mobile_app/models/User.dart';

class UserService{
  UserService();
  static late User user;
  static bool loggedIn = false;
  static bool registered = false;


  Future<void> getUserData(UserLoginDTO userData) async {
    ///request user data from api
    try {
      var response = await http.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/'),
          body: {'login': userData.login, 'password': userData.password}
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        print(response.body);
        //loggedIn = true;

      }
    } catch(e) {
      print(e);
    }

    ///test user
    if(userData.password == "admin" && userData.login == "admin"){
      loggedIn = true;
      user = User(userId: 1, login: "admin", password: "admin", role: 1);
    }else{
      loggedIn = false;
    }
  }

  Future<void> registerUser(UserLoginDTO userData) async {
    ///call to api to register endpoint
    try {
      var response = await http.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/'),
          body: {'login': userData.login, 'password': userData.password}
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        print(response.body);

      }
    } catch(e) {
      print(e);
    }

    ///test user
    registered = true;
  }
}
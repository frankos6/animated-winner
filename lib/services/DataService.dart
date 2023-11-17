import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app/models/Alert.dart';
import 'package:mobile_app/models/Device.dart';
import 'package:mobile_app/services/UserService.dart';
import '../models/User.dart';
import 'Config.dart';

class DataService{
  DataService();

  static List<Device> devices = List<Device>.empty(growable: true);
  static List<Alert> alerts = List<Alert>.empty(growable: true);
  static List<User> users = List<User>.empty(growable: true);

  Future<void> getDevices() async {
    try {
      var response = await http.get(
          Uri.parse('${Config.ip}/device/list'),
          headers: {
            "Accept": "application/json",
            "Authorization": UserService.loginData
          }
      );
      devices = List<Device>.empty(growable: true);

      if(response.statusCode == 200){
        List devicesJson = jsonDecode(response.body);
        for(int i = 0; i < devicesJson.length; i++){
          devices.add(Device.fromJson(devicesJson[i]));
        }
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> getAlerts() async {
    try {
      var response = await http.get(
          Uri.parse('${Config.ip}/alerts?limit=20'),
          headers: {
            "Accept": "application/json",
            "Authorization": UserService.loginData
          }
      );

      if(response.statusCode == 200){

        alerts = List<Alert>.empty(growable: true);
        List alertsJson = jsonDecode(response.body);

        for(int i = 0; i < alertsJson.length; i++){
          alerts.add(Alert.fromJson(alertsJson[i]));
        }
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> getUsers() async {
    try {
      var response = await http.get(
          Uri.parse('${Config.ip}/user/list'),
          headers: {
            "Accept": "application/json",
            "Authorization": UserService.loginData
          }
      );
      if(response.statusCode == 200){
        users = List<User>.empty(growable: true);
        List usersJson = jsonDecode(response.body);

        for(int i = 0; i < usersJson.length; i++){
          users.add(User.fromJson(usersJson[i]));
        }
      }
    } catch(e) {
      print(e);
    }
  }

}
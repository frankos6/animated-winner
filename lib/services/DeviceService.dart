import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/Alert.dart';
import 'package:mobile_app/models/DeviceConfig.dart';
import 'package:mobile_app/models/Humidity.dart';
import 'package:mobile_app/models/Temperature.dart';
import '../models/Device.dart';
import 'Config.dart';
import 'UserService.dart';

class DeviceService{
  late Device device;
  late DeviceConfig config;
  List<Alert> alerts = List<Alert>.empty(growable: true);
  List<Temperature> temperature = List<Temperature>.empty(growable: true);
  List<Humidity> humidity = List<Humidity>.empty(growable: true);
  bool gotConfig = false;

  DeviceService({required this.device});


  Future<void> getConfig() async {
    try {
      var response = await http.get(
          Uri.parse('${Config.ip}/device/${device.id}/config'),
          headers: {
            "Accept": "application/json",
            "Authorization": UserService.loginData
          }
      );
      
      if(response.statusCode == 200){
        
        config = DeviceConfig.fromJson(jsonDecode(response.body));
        gotConfig = true;
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> updateConfig() async {
    try {
      var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if(response.statusCode == 200){


      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> getAlerts() async {
    try {
      var response = await http.get(
          Uri.parse('${Config.ip}/device/${device.id}/alerts'),
          headers: {
            "Accept": "application/json",
            "Authorization": UserService.loginData
          }
      );

      alerts = List<Alert>.empty(growable: true);
      List alertsJson = jsonDecode(response.body);
      alertsJson = alertsJson.reversed.toList();

      for(int i = 0; i < alertsJson.length; i++){
        alerts.add(Alert.fromJson(alertsJson[i]));
      }

    } catch(e) {
      print(e);
    }
  }

  Future<void> getData() async {
    try {
      var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if(response.statusCode == 200){
        //print(response.body);
        temperature = List<Temperature>.empty(growable: true);
        humidity = List<Humidity>.empty(growable: true);

        for (int i = 1; i < 7; i++) {
          temperature.add(Temperature(
              temperature: Random().nextInt(2) + 20,
              time: DateTime(2023, 10, 24, 9, i)));
        }

        for (int i = 1; i < 7; i++) {
          humidity.add(
            Humidity(humidity: Random().nextInt(20)+80, time: DateTime(2023, 10, 24, 9, i)),
          );
        }

      }
    } catch(e) {
      print(e);
    }
  }

}
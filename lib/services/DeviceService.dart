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
        var configJson = jsonDecode(response.body);
        config = DeviceConfig.fromJson(configJson["params"]);
        config.deviceId = device.id;
        gotConfig = true;
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> updateConfig(DeviceConfig newConfig) async {
    try {
      var response = await http.put(
        Uri.parse('${Config.ip}/device/${device.id}/config'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": UserService.loginData
        },
        body: jsonEncode(newConfig.toMap())
      );

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
      var response = await http.get(
          Uri.parse('${Config.ip}/device/${device.id}/data?limit=6'),
          headers: {
            "Accept": "application/json",
            "Authorization": UserService.loginData
          }
      );

      print("data ${response.body}");

      if(response.statusCode == 200){
        temperature = List<Temperature>.empty(growable: true);
        humidity = List<Humidity>.empty(growable: true);

        var data = jsonDecode(response.body);

        for(int i = 0; i < data.length; i++){
          DateTime timestamp =  DateTime.parse(data[i]["timestamp"]);
          temperature.add(Temperature(temperature: data[i]["payload"]["temperature"], time: timestamp));
          humidity.add(Humidity(humidity: data[i]["payload"]["humidity"], time: timestamp));
        }
      }
    } catch(e) {
      print(e);
    }
  }

}
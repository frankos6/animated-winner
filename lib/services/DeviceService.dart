import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:mobile_app/models/Alert.dart';
import 'package:mobile_app/models/DeviceConfig.dart';
import 'package:mobile_app/models/Humidity.dart';
import 'package:mobile_app/models/Temperature.dart';

class DeviceService{
  late int deviceId;
  List<Alert> alerts = List<Alert>.empty(growable: true);
  late DeviceConfig config;
  bool gotConfig = false;
  List<Temperature> temperature = List<Temperature>.empty(growable: true);
  List<Humidity> humidity = List<Humidity>.empty(growable: true);

  DeviceService({required this.deviceId});

  Future<void> getConfig() async {
    try {
      var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if(response.statusCode == 200){
        //print(response.body);

        config = DeviceConfig(deviceId: deviceId, dsf: 9600, maxTemp: 30, maxHum: 80);
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
      var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if(response.statusCode == 200){

        /// alerts order by date time
        alerts = [
          Alert(alertId: 3, deviceId: deviceId, timestamp: "12:33", payload: "wet"),
          Alert(alertId: 4, deviceId: deviceId, timestamp: "12:37", payload: "Overheat"),
        ];
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
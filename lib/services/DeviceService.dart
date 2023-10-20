import 'package:http/http.dart' as http;
import 'package:mobile_app/models/Alert.dart';
import 'package:mobile_app/models/DeviceConfig.dart';

class DeviceService{
  late int deviceId;
  List<Alert> alerts = List<Alert>.empty(growable: true);
  late DeviceConfig config;
  bool gotConfig = false;

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



}
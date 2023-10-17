import 'package:http/http.dart' as http;
import 'package:mobile_app/models/Alert.dart';
import 'package:mobile_app/models/Device.dart';

class DataService{
  DataService();

  static List<Device> devices = List<Device>.empty(growable: true);
  static List<Alert> alerts = List<Alert>.empty(growable: true);

  Future<void> getDevices() async {
    try {
      var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if(response.statusCode == 200){
        //print(response.body);

        devices = [
          Device(id: 1, name: "dev1", location: "ogródek", isConnected: true, lastSeen: "10:08"),
          Device(id: 2, name: "device2", location: "dach", isConnected: true, lastSeen: "10:08"),
          Device(id: 3, name: "dev3", location: "taras", isConnected: false, lastSeen: "10:09"),
        ];
      }
    } catch(e) {
      print(e);
    }
  }

  Future<void> getAlerts() async {
    try {
      var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if(response.statusCode == 200){
        //print(response.body);

        /// alerts order by date time
        alerts = [
          Alert(alertId: 1, deviceId: 2, timestamp: "12:33", payload: "Overheat"),
          Alert(alertId: 2, deviceId: 3, timestamp: "12:37", payload: "Moisture"),
        ];
      }
    } catch(e) {
      print(e);
    }
  }

}
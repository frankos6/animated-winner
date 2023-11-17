import 'dart:convert';

class Alert{
  late int deviceId;
  late String timestamp;
  late String payload;

  Alert({
    required this.deviceId,
    required this.timestamp,
    required this.payload
  });

  Alert.fromJson(Map<String, dynamic> json){
    deviceId = json['DeviceId'];
    payload = json['message'];
    payload = utf8.decode(payload.codeUnits);
    DateTime date = DateTime.parse(json['timestamp']);
    timestamp = "${date.day}.${date.month}.${date.year-2000} ${date.hour}:${date.minute}:${date.second}";
  }
}
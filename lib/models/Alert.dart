class Alert{
  late int alertId;
  late int deviceId;
  late String timestamp;
  late String payload;

  Alert({
    required this.alertId,
    required this.deviceId,
    required this.timestamp,
    required this.payload
  });

  Alert.fromJson(Map<String, dynamic> json){
    alertId = json['id'];
    deviceId = json['deviceId'];
    timestamp = json['time'];
    payload = json['payload'];
  }
}
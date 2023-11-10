class DeviceConfig{
  late int deviceId;
  late int dsf;
  late int maxTemp;
  late int maxHum;
  late int minTemp;
  late int minHum;

  DeviceConfig({
    required this.deviceId,
    required this.dsf,
    required this.maxTemp,
    required this.maxHum,
    required this.minHum,
    required this.minTemp
});

  DeviceConfig.fromJson(Map<String, dynamic> json){
    deviceId = json['deviceId'];
    dsf = json['frequency'];
    maxTemp = json['maxTemp'];
    minTemp = json['minTemp'];
    maxHum = json['maxHum'];
    minHum = json['minHum'];
  }
}
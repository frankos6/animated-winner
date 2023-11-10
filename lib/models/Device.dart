import 'dart:convert';

class Device{
  late int id;
  late String name;
  late String location;
  late bool isConnected;
  late String lastSeen;

  Device({
    required this.id,
    required this.name,
    required this.location,
    required this.isConnected,
    required this.lastSeen
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'isConnected': isConnected,
      'lastSeen': lastSeen
    };
  }

  Device.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    name = utf8.decode(name.codeUnits);
    location = json['location'];
    location = utf8.decode(location.codeUnits);
    isConnected = json['isConnected'];
    if(json['lastSeen'] != null){
      lastSeen = json['lastSeen'];
    }else{
      lastSeen = "null";
    }
  }
}
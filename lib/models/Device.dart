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
    location = json['location'];
    isConnected = json['isConnected'];
    lastSeen = json['lastSeen'];
  }
}
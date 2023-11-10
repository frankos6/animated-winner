class User{
  late int userId;
  late String login;
  late String created;
  late bool isAdmin;

  User({
    required this.userId,
    required this.login,
    required this.created,
    required this.isAdmin
  });

  User.fromJson(Map<String, dynamic> json){
    userId = json['id'];
    login = json['username'];
    isAdmin = json['isAdmin'];
    created = json['createdAt'];
  }
}
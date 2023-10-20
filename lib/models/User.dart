class User{
  late int userId;
  late String login;
  late String password;
  late bool isAdmin;

  User({
    required this.userId,
    required this.login,
    required this.password,
    required this.isAdmin
  });
}
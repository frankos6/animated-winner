class UserLoginDTO{
  late String login;
  late String password;

  UserLoginDTO({
    required this.login,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return {
      'username': login,
      'password': password,
    };
  }
}
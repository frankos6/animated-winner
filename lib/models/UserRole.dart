class UserRole{

  late int roleId;
  late String roleName;
  late List<String> permissions;

  UserRole({
    required this.roleId,
    required this.roleName,
    required this.permissions
  });
}
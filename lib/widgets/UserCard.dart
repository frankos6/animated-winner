import 'package:flutter/material.dart';
import 'package:mobile_app/services/DataService.dart';
import 'package:mobile_app/services/UserService.dart';

class UserCard extends StatefulWidget {
  final int index;
  const UserCard({super.key, required this.index});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool selectedValue = false;

  @override
  void initState() {
    super.initState();
    selectedValue = DataService.users[widget.index].isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(DataService.users[widget.index].login)
              ),
              Expanded(
                child: DropdownButton(
                  value: selectedValue,
                  items: const [
                    DropdownMenuItem(value: false, child: Text("Użytkownik")),
                    DropdownMenuItem(value: true, child: Text("Administrator")),
                  ],
                  onChanged: (value) {
                    UserService userService = UserService();
                    setState(() {
                      DataService.users[widget.index].isAdmin = value!;
                      selectedValue = value;
                      userService.changeUserRole(widget.index, value);
                    });
                  },
                )
              )
            ],
          )),
    );
  }
}

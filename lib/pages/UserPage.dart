import 'package:flutter/material.dart';
import 'package:mobile_app/pages/LoginPage.dart';
import 'package:mobile_app/services/DataService.dart';
import 'package:mobile_app/services/UserService.dart';

import '../services/Themes.dart';
import '../widgets/UserCard.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Użytkownik"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Themes.darkBlue, Themes.lightBlue],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Zalogowano na: ${UserService.user.login}", style: const TextStyle(fontSize: 16)),
                    ButtonTheme(
                        minWidth: 100,
                        child: TextButton(
                            onPressed: () {
                              UserService userService = UserService();
                              userService.logOut();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
                            },
                            child: const Text("Wyloguj",
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ))),
                  ],
                ),
              ),
            ),
            if(UserService.user.isAdmin)
              Expanded(
                child: ListView.builder(
                  itemCount: DataService.users.length,
                  itemBuilder: (context, index) => UserCard(index: index),
                ),
              )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_app/services/DataService.dart';

import '../services/Themes.dart';
import '../services/UserService.dart';
import 'MainPage.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getData() async {
    DataService dataService = DataService();

    await dataService.getDevices();
    await dataService.getAlerts();

    if(UserService.user.isAdmin){
      await dataService.getUsers();
    }

    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Themes.darkBlue, Themes.lightBlue],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
      child: Center(child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: SpinKitRing(
          color: Colors.blue,
        ),
      ),),
      ),
    );
  }
}

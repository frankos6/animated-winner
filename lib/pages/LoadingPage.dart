import 'package:flutter/material.dart';
import 'package:mobile_app/models/Device.dart';
import 'package:mobile_app/services/DataService.dart';

import '../services/Themes.dart';
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

    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_app/pages/AlertsPage.dart';
import 'package:mobile_app/pages/AllDevicesPage.dart';
import '../models/Device.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  PageController pageController = PageController(
      initialPage: 0,
      keepPage: true
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [
          AllDevicesPage(),
          AlertsPage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.blue,
      ),
    );
  }
}

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(0)
              ),
              onPressed: (){
                pageController.animateToPage(0, duration: Duration(microseconds: 500), curve: Curves.linear);
              }, child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.devices),
                  Text("Urządzenia")
                ],
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(0)
              ),
              onPressed: (){
                pageController.animateToPage(1, duration: Duration(microseconds: 500), curve: Curves.linear);
              }, child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.announcement),
                Text("Alerty")
              ],
            ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(0)
              ),
              onPressed: (){
                pageController.animateToPage(2, duration: Duration(microseconds: 500), curve: Curves.linear);
              }, child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                Text("Użytkownik")
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}

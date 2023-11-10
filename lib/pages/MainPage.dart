import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/pages/AlertsPage.dart';
import 'package:mobile_app/pages/AllDevicesPage.dart';
import 'package:mobile_app/pages/UserPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: currentPage);

    return Scaffold(
      body: PageView(
        controller: pageController,
        pageSnapping: true,
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        children: const [
          AllDevicesPage(),
          AlertsPage(),
          UserPage()
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
                pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                setState(() {
                  currentPage = 0;
                });
              }, child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(currentPage == 0 ? Icons.view_module : Icons.view_module_outlined),
                  const Text("Urządzenia")
                ],
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(0)
              ),
              onPressed: (){
                pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                setState(() {
                  currentPage = 1;
                });
              }, child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(currentPage == 1 ? Icons.announcement : Icons.announcement_outlined),
                const Text("Alerty")
              ],
            ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(0)
              ),
              onPressed: (){
                pageController.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                setState(() {
                  currentPage = 2;
                });
              }, child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(currentPage == 2 ? Icons.person : Icons.person_outline),
                const Text("Użytkownik")
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}

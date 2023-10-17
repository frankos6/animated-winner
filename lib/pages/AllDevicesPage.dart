import 'package:flutter/material.dart';
import '../models/Device.dart';
import '../services/DataService.dart';
import '../services/Themes.dart';

class AllDevicesPage extends StatefulWidget {
  const AllDevicesPage({super.key});

  @override
  State<AllDevicesPage> createState() => _AllDevicesPageState();
}

class _AllDevicesPageState extends State<AllDevicesPage> {
  List<Device> devices = DataService.devices;
  ScrollController scrollController = ScrollController();

  getDevices() async {
    DataService dataService = DataService();
    await dataService.getAlerts();
    setState(() {
      devices = DataService.devices;
    });
  }

  @override
  void initState() {
    super.initState();
    if (DataService.devices.isEmpty) {
      getDevices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Urządzenia"),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                getDevices();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Themes.darkBlue, Themes.lightBlue],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
        child: ListView.builder(
            controller: scrollController,
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("opening device page");
                },
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Text("device")
                  ),
                ),
              );
            }),
      ),
    );
  }
}

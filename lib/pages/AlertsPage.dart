import 'package:flutter/material.dart';
import 'package:mobile_app/services/DataService.dart';

import '../models/Alert.dart';
import '../services/Themes.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  ScrollController scrollController = ScrollController();
  List<Alert> alerts = DataService.alerts;

  getAlerts() async {
    DataService dataService = DataService();
    await dataService.getAlerts();
    setState(() {
      alerts = DataService.alerts;
    });
  }

  @override
  void initState() {
    super.initState();
    if (DataService.alerts.isEmpty) {
      getAlerts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerty"),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                getAlerts();
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
            itemCount: alerts.length,
            itemBuilder: (context, index) {
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
                          child: Column(
                            children: [
                              Text(
                                DataService.devices
                                    .firstWhere((element) =>
                                        element.id == alerts[index].deviceId)
                                    .name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              Text("Id: ${alerts[index].deviceId}",
                                  style: const TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(children: [
                            Text("${alerts[index].payload}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("${alerts[index].timestamp}",
                                style: const TextStyle(fontSize: 16))
                          ]),
                        )
                      ],
                    )),
              );
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_app/pages/ConfigPage.dart';
import 'package:mobile_app/services/DataService.dart';
import 'package:mobile_app/services/DeviceService.dart';
import 'package:mobile_app/services/UserService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DevicePage extends StatefulWidget {
  final int deviceId;
  const DevicePage({super.key, required this.deviceId});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
 late DeviceService deviceService;
 getData() async {
   await deviceService.getConfig();
   await deviceService.getAlerts();
   setState(() {

   });
 }

 @override
  void initState() {
   deviceService = DeviceService(deviceId: widget.deviceId);
   getData();
   super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DataService.devices[widget.deviceId].name),
          elevation: 2,
          actions: [
            if (UserService.user.isAdmin &&
                DataService.devices[widget.deviceId].isConnected)
              IconButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ConfigPage(deviceId: widget.deviceId)));
                    }
                  },
                  icon: const Icon(Icons.edit))
          ],
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.all(6),
                    child: const Text("Urządzenie",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                Container(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nazwa: ${DataService.devices[widget.deviceId].name}", style: const TextStyle(fontSize: 16)),
                            Text("Ostatnio widziano: ${DataService.devices[widget.deviceId].lastSeen}", style: const TextStyle(fontSize: 16)),
                            if(deviceService.gotConfig)
                            Text("Częstotliwość wysyłania danych: ${deviceService.config.dsf}", style: const TextStyle(fontSize: 16)),

                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lokalizacja: ${DataService.devices[widget.deviceId].location}", style: const TextStyle(fontSize: 16)),
                            Text(DataService.devices[widget.deviceId].isConnected ? "Połączony": "Niepołączony", style: const TextStyle(fontSize: 16)),
                            if(deviceService.gotConfig)
                              Text("Max. temperatura: ${deviceService.config.maxTemp}°C", style: const TextStyle(fontSize: 16)),
                            if(deviceService.gotConfig)
                              Text("Max. wilgotność: ${deviceService.config.maxHum}%", style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.all(6),
                    child: const Text("Alerty",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                      itemCount: deviceService.alerts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15))),
                          margin: const EdgeInsets.all(10),
                          color: Colors.white,
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("${deviceService.alerts[index].timestamp}: ",
                                      style: const TextStyle(fontSize: 16)),
                                  Expanded(
                                    child: Text("${deviceService.alerts[index].payload}",
                                        style: const TextStyle(
                                            fontSize: 16)),
                                  )
                                ],
                              )),
                        );
                      }),
                ),
                ///https://pub.dev/packages/syncfusion_flutter_charts
                SfCartesianChart(
                )
              ],
            )
          ],
        ));
  }
}

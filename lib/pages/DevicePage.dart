import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_app/models/Humidity.dart';
import 'package:mobile_app/models/Temperature.dart';
import 'package:mobile_app/pages/ConfigPage.dart';
import 'package:mobile_app/services/DeviceService.dart';
import 'package:mobile_app/services/UserService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/Device.dart';

class DevicePage extends StatefulWidget {
  final Device device;
  const DevicePage({super.key, required this.device});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late DeviceService deviceService;
  TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  bool gotData = false;

  getData() async {
    await deviceService.getConfig();
    await deviceService.getAlerts();
    await deviceService.getData();
    if (context.mounted) {
      setState(() {
        gotData = true;
      });
    }
  }

  @override
  void initState() {
    /// TODO: change req admin to edit
    super.initState();
    gotData = false;
    deviceService = DeviceService(device: widget.device);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (gotData) {
      return Scaffold(
          appBar: AppBar(
            title: Text(deviceService.device.name),
            elevation: 2,
            actions: [
              IconButton(
                  onPressed: () {
                    getData();
                  },
                  icon: const Icon(Icons.refresh)),
              ///if (UserService.user.isAdmin && widget.device.isConnected) ////////////////////////////////////////////////////////////
                IconButton(
                    onPressed: () {
                      if (context.mounted) {
                        if (gotData) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfigPage(
                                    device: widget.device,
                                      deviceConfig: deviceService.config)));
                        }
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
                              Text(
                                  "Nazwa: ${widget.device.name}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  "Ostatnio widziano: ${widget.device.lastSeen}",
                                  style: const TextStyle(fontSize: 16)),
                              if (deviceService.gotConfig)
                                Text(
                                    "Częstotliwość wysyłania danych: ${deviceService.config.dsf}",
                                    style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Lokalizacja: ${widget.device.location}",
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  widget.device.isConnected
                                      ? "Połączony"
                                      : "Niepołączony",
                                  style: const TextStyle(fontSize: 16)),
                              if (deviceService.gotConfig)
                                Text(
                                    "Max. temperatura: ${deviceService.config.maxTemp}°C",
                                    style: const TextStyle(fontSize: 16)),
                              if (deviceService.gotConfig)
                                Text(
                                    "Max. wilgotność: ${deviceService.config.maxHum}%",
                                    style: const TextStyle(fontSize: 16)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            margin: const EdgeInsets.all(10),
                            color: Colors.white,
                            child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.warning,
                                        color: Colors.redAccent),
                                    const SizedBox(width: 10),
                                    Text(
                                        "${deviceService.alerts[index].timestamp}: ",
                                        style: const TextStyle(fontSize: 16)),
                                    Expanded(
                                      child: Text(
                                          "${deviceService.alerts[index].payload}",
                                          style: const TextStyle(fontSize: 16)),
                                    )
                                  ],
                                )),
                          );
                        }),
                  ),
                  SfCartesianChart(
                    title: ChartTitle(text: "Temperatura"),
                    tooltipBehavior: tooltipBehavior,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    series: getTemperatureData(),
                  ),
                  SfCartesianChart(
                    title: ChartTitle(text: "Wilgotność"),
                    tooltipBehavior: tooltipBehavior,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    series: getHumidityData(),
                  )
                ],
              )
            ],
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.device.name),
          elevation: 2,
        ),
        body: const Center(
          child: SpinKitRing(
            color: Colors.blue,
          ),
        ),
      );
    }
  }

  List<LineSeries<Temperature, String>> getTemperatureData() {
    List<Temperature> temperatureDataList =
        List<Temperature>.empty(growable: true);
    temperatureDataList = deviceService.temperature;

    return [
      LineSeries<Temperature, String>(
          name: "Wilgotność",
          dataSource: temperatureDataList,
          xValueMapper: (Temperature temp, _) =>
              (temp.time.hour < 10
                  ? "0${temp.time.hour}"
                  : "${temp.time.hour}") +
              (temp.time.minute < 10
                  ? ":0${temp.time.minute}"
                  : ":${temp.time.minute}") +
              (temp.time.second < 10
                  ? ":0${temp.time.second}"
                  : ":${temp.time.second}"),
          yValueMapper: (Temperature temp, _) => temp.temperature)
    ];
  }

  List<LineSeries<Humidity, String>> getHumidityData() {
    List<Humidity> humidityDataList = List<Humidity>.empty(growable: true);
    humidityDataList = deviceService.humidity;

    return [
      LineSeries<Humidity, String>(
          name: "Temperatura",
          dataSource: humidityDataList,
          xValueMapper: (Humidity hum, _) =>
              (hum.time.hour < 10 ? "0${hum.time.hour}" : "${hum.time.hour}") +
              (hum.time.minute < 10
                  ? ":0${hum.time.minute}"
                  : ":${hum.time.minute}") +
              (hum.time.second < 10
                  ? ":0${hum.time.second}"
                  : ":${hum.time.second}"),
          yValueMapper: (Humidity hum, _) => hum.humidity)
    ];
  }
}

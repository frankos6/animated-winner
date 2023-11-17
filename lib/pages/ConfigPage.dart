import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/models/DeviceConfig.dart';
import 'package:mobile_app/services/DeviceService.dart';
import '../models/Device.dart';
import '../services/DataService.dart';

class ConfigPage extends StatefulWidget {
  final DeviceConfig deviceConfig;
  final Device device;
  const ConfigPage({super.key, required this.deviceConfig, required this.device});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  late Device device;
  late DeviceConfig deviceConfig;

  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController dataSendFreqController;
  late TextEditingController maxTemperatureController;
  late TextEditingController minTemperatureController;
  late TextEditingController maxHumidityController;
  late TextEditingController minHumidityController;

  double margin = 25;

  @override
  void initState() {
    device = widget.device;
    deviceConfig = widget.deviceConfig;
    nameController = TextEditingController(text: device.name);
    locationController = TextEditingController(text: device.location);
    dataSendFreqController = TextEditingController(text: "${deviceConfig.dsf}");
    maxTemperatureController = TextEditingController(text: "${deviceConfig.maxTemp}");
    minTemperatureController = TextEditingController(text: "${deviceConfig.minTemp}");
    maxHumidityController = TextEditingController(text: "${deviceConfig.maxHum}");
    minHumidityController = TextEditingController(text: "${deviceConfig.minHum}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        elevation: 2,
        actions: [
          IconButton(
              onPressed: () async {
                bool valid = true;
                if (formKey.currentState!.validate()) {

                  DeviceConfig newConfig = DeviceConfig(
                    deviceId: widget.device.id,
                    dsf: int.parse(dataSendFreqController.text),
                    maxTemp: int.parse(maxTemperatureController.text),
                    minTemp: int.parse(minTemperatureController.text),
                    maxHum: int.parse(maxHumidityController.text),
                    minHum: int.parse(minHumidityController.text),
                  );

                  DeviceService deviceService = DeviceService(device: widget.device);
                  await deviceService.updateConfig(newConfig);

                  if(context.mounted){
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Zmieniono konfigurację urządzenia")
                        ));
                    Navigator.pop(context);
                  }
                }
                //change config
              },
              icon: const Icon(Icons.done)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const Text("Nazwa urządzenia:"),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Podaj wartość";
                  }
                  return null;
                },
              ),
              SizedBox(height: margin),
              const Text("Lokalizacja urządzenia:"),
              TextFormField(
                controller: locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Podaj wartość";
                  }
                  return null;
                },
              ),
              SizedBox(height: margin),
              const Text("Częstotliwość wysyłania danych:"),
              TextFormField(
                controller: dataSendFreqController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Podaj wartość";
                  } else if (int.tryParse(value)! <= 0) {
                    return "Podaj prawidłową wartość";
                  }
                  return null;
                },
              ),
              SizedBox(height: margin),
              const Text("Maksymalna temperatura:"),
              TextFormField(
                controller: maxTemperatureController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Podaj wartość";
                  }
                  return null;
                },
              ),
              SizedBox(height: margin),
              const Text("Minimalna temperatura:"),
              TextFormField(
                controller: minTemperatureController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.-]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Podaj wartość";
                  }
                  return null;
                },
              ),
              SizedBox(height: margin),
              const Text("Maksymalna wilgotność (%):"),
              TextFormField(
                controller: maxHumidityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Podaj wartość";
                  } else if (int.tryParse(value)! > 100) {
                    return "Podana wartość jest zbyt duża";
                  }
                  return null;
                },
              ),
              SizedBox(height: margin),
              const Text("Minimalna wilgotność (%):"),
              TextFormField(
                controller: minHumidityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Podaj wartość";
                  } else if (int.tryParse(value)! > 100) {
                    return "Podana wartość jest zbyt duża";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

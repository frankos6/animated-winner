import 'package:flutter/material.dart';

import '../models/Device.dart';
import '../services/DataService.dart';

class AllDevicesPage extends StatefulWidget {

  const AllDevicesPage({super.key});

  @override
  State<AllDevicesPage> createState() => _AllDevicesPageState();
}

class _AllDevicesPageState extends State<AllDevicesPage> {
  List<Device> devices = DataService.devices;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

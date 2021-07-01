import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';

class BtService {
  static FlutterBlue flutterBlue;
  static ScanResult scanResult;

  static void initBtService() {
    flutterBlue = FlutterBlue.instance;
  }

  static void scanBtDevices() {
    flutterBlue.startScan(timeout: Duration(seconds: 5));
  }

  static void connectToDevice(ScanResult newScanResult) async {
    scanResult = newScanResult;
    await scanResult.device
        .connect(timeout: Duration(seconds: 20), autoConnect: false);
  }

  static void sendStringMessage(String message) async {
    List<BluetoothService> services =
        await scanResult.device.discoverServices();
    services.forEach((service) async {
      print(services);
      for (BluetoothCharacteristic c in service.characteristics) {
        print('service characteristics');
        print(service.characteristics);
        await c.write(utf8.encode(message));
      }
    });
  }

  static void sendBytesMessage(List<int> message) async {
    List<BluetoothService> services =
        await scanResult.device.discoverServices();
    services.forEach((service) async {
      print(services);
      for (BluetoothCharacteristic c in service.characteristics) {
        print('service characteristics');
        print(service.characteristics);
        await c.write(message);
      }
    });
  }
}

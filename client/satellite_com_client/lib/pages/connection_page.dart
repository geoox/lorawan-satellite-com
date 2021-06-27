import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:satellite_com_client/utils/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConnectionPageState();
}

class ConnectionPageState extends State<ConnectionPage> {
  String message;
  FlutterBlue flutterBlue;
  bool isConnected = false;
  ScanResult scanResult;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    flutterBlue = FlutterBlue.instance;
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void onSendPress() async {
    List<BluetoothService> services =
        await this.scanResult.device.discoverServices();
    services.forEach((service) async {
      print('services');
      print(services);
      for (BluetoothCharacteristic c in service.characteristics) {
        print('service characteristics');
        print(service.characteristics);
        await c.write(utf8.encode(this.message));
      }
    });
  }

  void onScanPress() {
    print('scan pressed');
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    // flutterBlue.scanResults.listen((results) {
    //   for (ScanResult r in results) {
    //     // print(
    //     //     'id: ${r.device.id}; name: ${r.device.name}; type: ${r.device.type}; signal: ${r.rssi}; adv-date: ${r.advertisementData}');
    //     print(r.device.name + "\n");
    //   }
    // });
  }

  void onConnect(ScanResult scanResult) async {
    await scanResult.device
        .connect(timeout: Duration(seconds: 20), autoConnect: false);
    this.scanResult = scanResult;
    prefs.setBool(Keys.bluetoothKey, true); // set bt key to true
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Device connected via Bluetooth')));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    final conStatus = Text('BLE Connection: ' + isConnected.toString());

    final prompt = Text('Enter your message here...');

    final availableDevices = SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<BluetoothDevice>>(
            stream: Stream.periodic(Duration(seconds: 1))
                .asyncMap((_) => FlutterBlue.instance.connectedDevices),
            initialData: [],
            builder: (c, snapshot) => Column(
              children: snapshot.data
                  .map(
                    (d) => ListTile(
                      title: Text(d.name),
                      // subtitle: Text(d.id.toString()),
                      trailing: StreamBuilder<BluetoothDeviceState>(
                        stream: d.state,
                        initialData: BluetoothDeviceState.disconnected,
                        builder: (c, snapshot) {
                          if (snapshot.data == BluetoothDeviceState.connected) {
                            return ElevatedButton(
                              child: Text('Disconnect'),
                              onPressed: () {
                                d.disconnect();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Device disconnected')));
                              },
                            );
                          }
                          return Text(snapshot.data.toString());
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          StreamBuilder<List<ScanResult>>(
            stream: FlutterBlue.instance.scanResults,
            initialData: [],
            builder: (c, snapshot) => Column(
              children: snapshot.data
                  .map((r) => InkWell(
                        onTap: () => onConnect(r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              r.device.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              r.device.id.toString(),
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Divider(),
                            SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );

    final message = Card(
      color: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          maxLines: 8,
          decoration:
              InputDecoration.collapsed(hintText: "Enter your text here"),
          onChanged: (newText) {
            setState(() {
              this.message = newText;
            });
          },
        ),
      ),
    );

    final sendButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => onSendPress(),
        child: Text(
          "Send",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final scanButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => onScanPress(),
        child: Text(
          "Scan (Bluetooth)",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final verticalSpace = SizedBox(
      height: 15,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                children: [
                  prompt,
                  verticalSpace,
                  message,
                  verticalSpace,
                  sendButton,
                  verticalSpace,
                  scanButton,
                  verticalSpace,
                  availableDevices
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

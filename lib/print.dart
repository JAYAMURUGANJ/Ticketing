import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterSettings extends StatefulWidget {
  const PrinterSettings({Key? key}) : super(key: key);

  @override
  State<PrinterSettings> createState() => _PrinterSettingsState();
}

class _PrinterSettingsState extends State<PrinterSettings> {
  late SharedPreferences preferences;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  String selectedDevice_name = "";
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  @override
  void initState() {
    super.initState();
    //for getting already selected device
    getSharedPreferences();
    //for getting paired devices
    getDevices();
  }

  void getSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
    var deviceName = preferences.getString("device_name");
    var deviceAddress = preferences.getString("device_address");
    setState(() {
      selectedDevice_name = deviceName! + "[" + deviceAddress! + "]";
    });

    print(selectedDevice);
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Stettings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("BlueTooth Connection Status:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<BluetoothDevice>(
                    value: selectedDevice,
                    hint: const Text("Select Thermal Printer"),
                    onChanged: (device) async {
                      //save the selected device to shared preferences for later use in the app and set it as the selected device
                      preferences = await SharedPreferences.getInstance();

                      preferences.setString(
                          "device_name", device!.name.toString());
                      preferences.setString(
                          "device_address", device.address.toString());

                      setState(() {
                        selectedDevice = device;
                      });
                    },
                    items: devices
                        .map((e) => DropdownMenuItem(
                              child: Text(e.name!),
                              value: e,
                            ))
                        .toList()),

                //using toggel button to enable/disable bluetooth
                ElevatedButton(
                  child: const Text("Connect"),
                  onPressed: selectedDevice == null
                      ? null
                      : () async {
                          await printer.connect(selectedDevice!);
                          await printer.isConnected.then((isConnected) {
                            if (isConnected!) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Connected"),
                                      content: const Text("Printer Connected"),
                                      actions: [
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          child: const Text("Ok"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Error"),
                                      content:
                                          const Text("Printer Not Connected"),
                                      actions: [
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          child: const Text("Ok"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
                          });
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

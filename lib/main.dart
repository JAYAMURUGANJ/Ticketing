// ignore_for_file: non_constant_identifier_names, unused_field

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'model/ticket_class.dart';
import 'print.dart';
import 'view/widget/ticket.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticketing App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Ticketing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  final TextEditingController _controller = TextEditingController();
  Color btnColor = const Color.fromARGB(255, 34, 36, 34);
  late List<TicketData> _choices;
  late double ticket_amt;
  double total_amt = 0.0;
  late int _defaultChoiceIndex;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  late BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;
  final formatter = NumberFormat.currency(
    locale: 'hi_IN',
    decimalDigits: 2,
    symbol: '',
  );
  DateTime now = DateTime.now();

  late String tally;
  late String date;
  late String time;
  late String ticket_name;
  late String ticket_price;

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await printer.getBondedDevices();
    } on PlatformException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get paired devices.'),
        ),
      );
    }

    printer.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _controller.text = "0";
    _choices = [
      TicketData(
          ticketId: 1, ticketName: 'Archanai Ticket', ticketAmount: 5.00),
      TicketData(
          ticketId: 2, ticketName: 'Kaapu Kattum Ticket', ticketAmount: 10.00),
      TicketData(
          ticketId: 3, ticketName: 'Paal Kudam Ticket', ticketAmount: 15.00),
      TicketData(
          ticketId: 4,
          ticketName: 'Silver Kavasam Ticket',
          ticketAmount: 201.00),
      TicketData(
          ticketId: 5, ticketName: 'Special Entrance', ticketAmount: 10.00),
      TicketData(
          ticketId: 6, ticketName: 'Special Entrance', ticketAmount: 20.00),
      TicketData(
          ticketId: 7,
          ticketName: 'Thanga kavasam Ticket',
          ticketAmount: 1001.00),
      TicketData(
          ticketId: 8, ticketName: 'Abishega Ticket', ticketAmount: 101.00),
      TicketData(
          ticketId: 9,
          ticketName: 'Karumbu Thotil Ticket',
          ticketAmount: 10.00),
      TicketData(
          ticketId: 10,
          ticketName: 'Kaadhu kuthu Kaanikai Ticket',
          ticketAmount: 25.00),
      TicketData(
          ticketId: 11,
          ticketName: 'Sandhana Alangaram Ticket',
          ticketAmount: 151.00),
      TicketData(
          ticketId: 12,
          ticketName: 'Paavadai Kaanikai Ticket',
          ticketAmount: 5.00),
      TicketData(
          ticketId: 13,
          ticketName: 'Pillai Vidudhal Ticket',
          ticketAmount: 25.00),
      TicketData(ticketId: 14, ticketName: 'Pongal Ticket', ticketAmount: 5.00),
      TicketData(
          ticketId: 15, ticketName: 'Maa Villaku Ticket', ticketAmount: 5.00)
    ];
    _defaultChoiceIndex = _choices[0].ticketId! - 1;
    ticket_amt = _choices[0].ticketAmount!;
    tally = formatter.format(num.parse(total_amt.toString()));
  }

  void _incrementCounter() {
    setState(() {
      counter++;
      total_amt = ticket_amt * counter;
      tally = formatter.format(num.parse(total_amt.toString()));
    });
  }

  void _decrementCounter() {
    setState(() {
      counter--;
      total_amt = ticket_amt * counter;
      tally = formatter.format(num.parse(total_amt.toString()));
    });
  }

  void _resetCounter() {
    counter = 0;
    setState(() {
      total_amt = 0.0;
      tally = formatter.format(num.parse(total_amt.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PrinterSettings();
              }));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: _choices.length,
                  itemBuilder: (BuildContext context, int index) {
                    var chipvalue = _choices[index];
                    return ChoiceChip(
                      label: Row(
                        children: [
                          //custom circle icon
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 10,
                            child: Text(_choices[index].ticketId.toString()),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              _choices[index].ticketName.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      selected: _defaultChoiceIndex == index,
                      selectedColor: btnColor,
                      onSelected: (bool selected) {
                        _resetCounter();
                        setState(() {
                          _defaultChoiceIndex = selected ? index : 0;
                          ticket_amt = chipvalue.ticketAmount!;
                        });
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      labelStyle: const TextStyle(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 5.0,
                    mainAxisExtent: 35.0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: TicketShape(
                t_id: (_defaultChoiceIndex + 1),
                t_name: _choices[_defaultChoiceIndex].ticketName,
                t_date: DateFormat('dd-MM-yyyy').format(now).toString(),
                t_time: DateFormat('hh:mm:ss ').format(now).toString(),
                t_price: formatter.format(num.parse(
                    _choices[_defaultChoiceIndex].ticketAmount.toString())),
                t_count: counter,
                t_total: tally.toString(),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    constraints:
                        const BoxConstraints.tightFor(width: 30, height: 30),
                    elevation: 6.0,
                    onPressed: counter == 0
                        ? () {
                            _resetCounter();
                            _controller.text = counter.toString();
                          }
                        : () {
                            _decrementCounter();
                            _controller.text = counter.toString();
                          },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15 * 0.2)),
                    fillColor: btnColor,
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20 * 0.8,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          counter = int.parse(value);
                          _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: value.length));
                          total_amt = ticket_amt * counter;
                          tally =
                              formatter.format(num.parse(total_amt.toString()));
                        });
                      },
                    ),
                  ),
                  RawMaterialButton(
                    constraints:
                        const BoxConstraints.tightFor(width: 30, height: 30),
                    elevation: 6.0,
                    onPressed: () {
                      _incrementCounter();
                      _controller.text = counter.toString();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15 * 0.2)),
                    fillColor: btnColor,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20 * 0.8,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                height: 52,
                decoration: BoxDecoration(
                  color: btnColor,
                ),
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      TicketShapeIcon(),
                      Text(
                        'Book',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    setState(() {
                      ticket_price = formatter.format(num.parse(
                          _choices[_defaultChoiceIndex]
                              .ticketAmount!
                              .toString()));
                      ticket_name = _choices[_defaultChoiceIndex].ticketName!;
                      time = DateFormat('hh:mm:ss a').format(now).toString();
                      date = DateFormat('dd/MM/yyyy').format(now).toString();
                    });
                    if ((await printer.isConnected)!) {
                      printer.printQRcode("R000062204190001906", 150, 150, 1);
                      printer.printNewLine();
                      //printer.printCustom('Text','size','align');
                      printer.printCustom(
                          'Arulmigu Vadapalani Aandavar Temple,Vadapalani',
                          1,
                          1);
                      printer.printCustom("Chennai [TM00006]", 1, 1);
                      printer.printNewLine();
                      printer.printCustom(ticket_name, 1, 1);
                      printer.printNewLine();
                      printer.printCustom(date, 2, 1);
                      printer.printNewLine();
                      printer.printLeftRight(
                          "Receipt No", ":R000062204190001906", 1);
                      printer.printNewLine();
                      printer.printLeftRight("Receipt Date", ":$date $time", 1);
                      printer.printNewLine();
                      printer.printCustom(
                          "$counter * RS $ticket_price = RS $tally", 1, 1);
                      printer.printNewLine();
                      printer.printCustom(
                          "Deputy Commissioner Cum Exec Officer", 0, 1);
                      printer.printNewLine();
                      printer.printNewLine();
                      printer.paperCut();
                    } else {
                      print('Printer is not connected');
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

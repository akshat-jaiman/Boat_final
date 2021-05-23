import 'dart:async';

import 'package:boat/net/getdate.dart';
import 'package:boat/ui/pdfview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userid = FirebaseAuth.instance.currentUser.email;
  List _items = [];
  String _timeString;

  DateTime now = new DateTime.now();
  DateTime selectedDate = DateTime.now();
  int indexjson;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    readJson();
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();

    indexjson = getDate(selectedDate) - 1;
    print(indexjson);
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/boatdata.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["data"];
    });
  }

  void _getCurrentTime() {
    setState(() {
      _timeString =
          "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        indexjson = getDate(selectedDate) - 1;
        print(indexjson);
      });
  }

  bool _comapreTide(String s) {
    double i = double.parse(s);
    if (i > 4) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.verified_user),
                    radius: 35,
                  ),
                  Text(userid),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                print('pdf tapped');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PdfView()));
              },
              leading: Icon(Icons.picture_as_pdf),
              title: Text('Open pdf'),
            ),
            ListTile(
              onTap: () {
                print('Log out');
                _signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Center(
                    child: Text(
                  _timeString,
                  style: TextStyle(fontSize: 30),
                )),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Center(
                      child: Text('select date'),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amberAccent,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                indexjson--;
                                selectedDate =
                                    selectedDate.subtract(Duration(days: 1));
                                print(indexjson);
                                print(selectedDate.day);
                              },
                              child: Icon(Icons.arrow_back),
                            ),
                            Text(
                              selectedDate.day.toString(),
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              '-',
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              selectedDate.month.toString(),
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              '-',
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              selectedDate.year.toString(),
                              style: TextStyle(fontSize: 25),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  indexjson++;
                                  selectedDate =
                                      selectedDate.add(Duration(days: 1));
                                  print(indexjson);
                                  print(selectedDate.day);
                                });
                              },
                              child: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Tide')),
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('m')),
                            DataColumn(label: Text('Time')),
                            DataColumn(label: Text('Gate')),
                          ],
                          rows: [
                            DataRow(cells: <DataCell>[
                              DataCell(_comapreTide(_items[indexjson]["tide1"])
                                  ? Text('High')
                                  : Text('low')),
                              DataCell(
                                Text(_items[indexjson]["openTime1"]),
                              ),
                              DataCell(Text(_items[indexjson]["tide1"])),
                              DataCell(Text(_items[indexjson]["closeTime1"])),
                              DataCell(Text(_items[indexjson]["status1"])),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(_comapreTide(_items[indexjson]["tide2"])
                                  ? Text('High')
                                  : Text('low')),
                              DataCell(
                                Text(_items[indexjson]["openTime2"]),
                              ),
                              DataCell(Text(_items[indexjson]["tide2"])),
                              DataCell(Text(_items[indexjson]["closeTime2"])),
                              DataCell(Text(_items[indexjson]["status2"])),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(_comapreTide(_items[indexjson]["tide3"])
                                  ? Text('High')
                                  : Text('low')),
                              DataCell(
                                Text(_items[indexjson]["openTime3"]),
                              ),
                              DataCell(Text(_items[indexjson]["tide3"])),
                              DataCell(Text(_items[indexjson]["closeTime3"])),
                              DataCell(Text(_items[indexjson]["status3"])),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(_items[indexjson]["tide4"] == "-"
                                  ? Text("-")
                                  : _comapreTide(_items[indexjson]["tide4"])
                                      ? Text('High')
                                      : Text('low')),
                              DataCell(
                                Text(_items[indexjson]["openTime4"]),
                              ),
                              DataCell(Text(_items[indexjson]["tide4"])),
                              DataCell(Text(_items[indexjson]["closeTime4"])),
                              DataCell(Text(_items[indexjson]["status4"])),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: Divider(
                  height: 10,
                  thickness: 5,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

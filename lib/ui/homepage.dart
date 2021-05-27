import 'dart:async';

import 'package:boat/net/getdate.dart';
import 'package:boat/ui/authentication.dart';
import 'package:boat/ui/pdfview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userid = FirebaseAuth.instance.currentUser.email;
  List _items = [];
  String _timeString, _utcTimeString;

  DateTime now = new DateTime.now();
  DateTime selectedDate = DateTime.now();

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    readJson();
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
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
      _utcTimeString =
          "${DateTime.now().toUtc().hour} : ${DateTime.now().toUtc().minute} :${DateTime.now().toUtc().second}";
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Map',
          ),
        ],
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
              onTap: () async {
                print('Log out');

                _signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');
                var email = prefs.getString('email');
                print(email);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Authentication()));
              },
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
            ),
          ],
        ),
      ),
      body: _items.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Current Time   ->   ",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                _timeString,
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "UTC Time   ->   ",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                _utcTimeString,
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      selectedDate = selectedDate
                                          .subtract(Duration(days: 1));

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
                                        selectedDate =
                                            selectedDate.add(Duration(days: 1));

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
                              color: Colors.white,
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
                                    DataCell(_comapreTide(
                                            _items[getDate(selectedDate)]
                                                ["tide1"])
                                        ? Image(
                                            image: AssetImage(
                                                'assets/hightide.png'))
                                        : Image(
                                            image: AssetImage(
                                                'assets/lowtide.png'))),
                                    DataCell(
                                      Text(_items[getDate(selectedDate)]
                                          ["openTime1"]),
                                    ),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["tide1"])),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["closeTime1"])),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["status1"])),
                                  ]),
                                  DataRow(cells: <DataCell>[
                                    DataCell(_comapreTide(
                                            _items[getDate(selectedDate)]
                                                ["tide2"])
                                        ? Image(
                                            image: AssetImage(
                                                'assets/hightide.png'))
                                        : Image(
                                            image: AssetImage(
                                                'assets/lowtide.png'))),
                                    DataCell(
                                      Text(_items[getDate(selectedDate)]
                                          ["openTime2"]),
                                    ),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["tide2"])),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["closeTime2"])),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["status2"])),
                                  ]),
                                  DataRow(cells: <DataCell>[
                                    DataCell(_comapreTide(
                                            _items[getDate(selectedDate)]
                                                ["tide3"])
                                        ? Image(
                                            image: AssetImage(
                                                'assets/hightide.png'))
                                        : Image(
                                            image: AssetImage(
                                                'assets/lowtide.png'))),
                                    DataCell(
                                      Text(_items[getDate(selectedDate)]
                                          ["openTime3"]),
                                    ),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["tide3"])),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["closeTime3"])),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["status3"])),
                                  ]),
                                  DataRow(cells: <DataCell>[
                                    DataCell(_items[getDate(selectedDate)]
                                                ["tide4"] ==
                                            "-"
                                        ? Text("-")
                                        : _comapreTide(
                                                _items[getDate(selectedDate)]
                                                    ["tide4"])
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/hightide.png'))
                                            : Image(
                                                image: AssetImage(
                                                    'assets/lowtide.png'))),
                                    DataCell(
                                      Text(_items[getDate(selectedDate)]
                                          ["openTime4"]),
                                    ),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["tide4"])),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["closeTime4"])),
                                    DataCell(Text(_items[getDate(selectedDate)]
                                        ["status4"])),
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

import 'dart:async';
import 'package:boat/net/getdate.dart';
import 'package:boat/ui/authentication.dart';
import 'package:boat/ui/pdfview.dart';

import 'package:boat/ui/userprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:boat/net/dayData.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestore = FirebaseFirestore.instance;
  var loggedinUser = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;

  List<String> closeTimes = [];
  String timeValue = null;
  var timeDiff = null;
  var dateIndex = null;
  bool dateIncreasd = false;

  List _items = [];
  String _timeString, _utcTimeString, _comapreTimeString;

  DateTime now = new DateTime.now();
  DateTime selectedDate = DateTime.now();

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    readJson();
    setState(() {
      _timeString =
          "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";

      _comapreTimeString = "${DateTime.now().hour}:${DateTime.now().minute}";
      Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    });
    DateTime todayDate = DateTime.now();

    dateIndex = getDate(todayDate);
    getDateData();
    Timer.periodic(Duration(seconds: 1), (Timer t1) => {_getTime()});
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/boatdata.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["data"];
    });
  }

  void _getCurrentTime() {
    if (this.mounted) {
      setState(() {
        _timeString =
            "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
        _comapreTimeString = "${DateTime.now().hour}:${DateTime.now().minute}";
        _utcTimeString =
            "${DateTime.now().toUtc().hour} : ${DateTime.now().toUtc().minute} :${DateTime.now().toUtc().second}";
      });
    }
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

  void _getTime() {
    var dateFormat = DateFormat("HH:mm");
    var outputFormat = DateFormat("HH:mm:ss");

    if (timeValue == "increase index") {
      dateIndex++;
      dateIncreasd = true;
      getDateData();
      return;
    }

    if (timeValue == null) return;
    if (mounted) {
      setState(() {
        var v = dateFormat.parse(timeValue);
        var currentTime =
            outputFormat.parse(outputFormat.format(DateTime.now()));
        var endTime = outputFormat.parse(outputFormat.format(v));

        if (dateIncreasd) {
          timeDiff = endTime.add(Duration(days: 1)).difference(currentTime);
        } else {
          timeDiff = endTime.difference(currentTime);
        }
        //var val = v.difference(dateFormat.parse(DateTime.now().toString()));
        // print(dateFormat
        //     .parse(timeValue)
        //     .difference(dateFormat.parse(currentTime)));

        // if (timeDiff < 0) {
        //   timeDiff += 24;
        // }

        if (timeDiff == Duration(seconds: 0)) {
          if (dateIncreasd) {
            dateIncreasd = false;
          }
          getDateData();
        }
      });
    }
  }

  bool compareDates(String d1, String d2) {
    if (d1 == "-") {
      return false;
    }

    var dateFormat = DateFormat("HH:mm");
    // print(dateFormat.parse(d1));
    // print(dateFormat.parse(d2));
    if (dateIncreasd) {
      return true;
    }
    return dateFormat.parse(d1).isAfter(dateFormat.parse(d2));
  }

  Future<void> getDateData() async {
    closeTimes = await dateData(dateIndex);
    //closeTimes = ["05:26", "11:43", "17:02", "17:04", "17:07"];
    // print(dateIndex);
    var outputFormat = DateFormat("HH:mm");
    var date = outputFormat.format(DateTime.now());

    timeValue = closeTimes.firstWhere((element) => compareDates(element, date),
        orElse: () => "increase index");
  }

  String getCurrentStatus() {
    String currentTime = "";
    String s1 = _items[getDate(selectedDate)]["closeTime1"];
    String s2 = _items[getDate(selectedDate)]["closeTime2"];
    String s3 = _items[getDate(selectedDate)]["closeTime3"];
    String s4 = _items[getDate(selectedDate)]["closeTime4"];

    if (_comapreTimeString[1] == ":") {
      _comapreTimeString = "0" + _comapreTimeString;
    }

    if (_comapreTimeString.length == 4) {
      _comapreTimeString = _comapreTimeString[0] +
          _comapreTimeString[1] +
          _comapreTimeString[2] +
          "0" +
          _comapreTimeString[3];
    }

    if (_comapreTimeString.compareTo(s1) < 0) {
      return _items[getDate(selectedDate)]["status1"];
    } else if (_comapreTimeString.compareTo(s2) < 0) {
      return _items[getDate(selectedDate)]["status2"];
    } else if (_comapreTimeString.compareTo(s3) < 0) {
      return _items[getDate(selectedDate)]["status3"];
    } else if (_comapreTimeString.compareTo(s4) < 0) {
      return _items[getDate(selectedDate)]["status4"];
    } else {
      if (_items[getDate(selectedDate)]["status4"] == "Lower") {
        return "Lower";
      } else {
        return "Raise";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _items.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                        Text(loggedinUser.email),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      print('Profile viewed');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfile()));
                    },
                    leading: Icon(Icons.account_circle),
                    title: Text('View Profile'),
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
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('email');
                      var email = prefs.getString('email');
                      print(email);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Authentication()));
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
                      height: 20,
                      child: getCurrentStatus() == "Raise"
                          ? Text("Currently Lowered")
                          : Text("Currently Raised"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40,
                      child: Text(
                          ' ${getCurrentStatus()} in ${timeDiff.toString().substring(0, 7)}'),
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
                  ],
                ),
              ),
            ),
          );
  }
}

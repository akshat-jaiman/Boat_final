import 'dart:async';

import 'package:boat/net/getdate.dart';
import 'package:boat/ui/authentication.dart';
import 'package:boat/ui/pdfview.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:boat/ui/userprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:boat/net/dayData.dart';
import 'package:google_fonts/google_fonts.dart';
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

  DateTime now = new DateTime.now().toUtc().add(Duration(hours: 1));
  DateTime selectedDate = DateTime.now().toUtc().add(Duration(hours: 1));

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    readJson();
    setState(() {
      _timeString =
          "${DateTime.now().toUtc().add(Duration(hours: 1)).hour.toString().padLeft(2, '0')} : ${DateTime.now().toUtc().minute.toString().padLeft(2, '0')} :${DateTime.now().toUtc().second.toString().padLeft(2, '0')}";

      _comapreTimeString =
          "${DateTime.now().toUtc().add(Duration(hours: 1)).hour.toString().padLeft(2, '0')}:${DateTime.now().toUtc().minute.toString().padLeft(2, '0')}";
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
            "${DateTime.now().toUtc().add(Duration(hours: 1)).hour.toString().padLeft(2, '0')} : ${DateTime.now().toUtc().minute.toString().padLeft(2, '0')} :${DateTime.now().toUtc().second.toString().padLeft(2, '0')}";
        _comapreTimeString =
            "${DateTime.now().toUtc().add(Duration(hours: 1)).hour.toString().padLeft(2, '0')}:${DateTime.now().toUtc().minute.toString().padLeft(2, '0')}";
        _utcTimeString =
            "${DateTime.now().toUtc().add(Duration(hours: 1)).hour.toString().padLeft(2, '0')} : ${DateTime.now().toUtc().minute.toString().padLeft(2, '0')} :${DateTime.now().toUtc().second.toString().padLeft(2, '0')}";
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

  int _comapreTide(String s) {
    if (s == '-') {
      return 3;
    }

    double i = double.parse(s);
    if (i > 4) {
      return 1;
    } else {
      return 2;
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
        var currentTime = outputFormat.parse(outputFormat
            .format(DateTime.now().toUtc().add(Duration(hours: 1))));
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
    var date =
        outputFormat.format(DateTime.now().toUtc().add(Duration(hours: 1)));

    timeValue = closeTimes.firstWhere((element) => compareDates(element, date),
        orElse: () => "increase index");
  }

  String getCurrentStatus() {
    String currentTime = "";
    String s1 = _items[getDate(now)]["closeTime1"];
    String s2 = _items[getDate(now)]["closeTime2"];
    String s3 = _items[getDate(now)]["closeTime3"];
    String s4 = _items[getDate(now)]["closeTime4"];
    if (s4 == "-") {
      s4 = s3;
    }

    if (_comapreTimeString.compareTo(s4) >= 0) {
      if (_items[getDate(now)]["status4"] == "-") {
        return _items[getDate(now)]["status3"];
      } else
        return _items[getDate(now)]["status4"];
    } else if (_comapreTimeString.compareTo(s3) >= 0) {
      return _items[getDate(now)]["status3"];
    } else if (_comapreTimeString.compareTo(s2) >= 0) {
      return _items[getDate(now)]["status2"];
    } else if (_comapreTimeString.compareTo(s1) >= 0) {
      return _items[getDate(now)]["status1"];
    } else {
      if (_items[getDate(now)]["status1"] == "Lower") {
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
              backgroundColor: Colors.blue.shade300,
              title: Text(
                'Home Page',
                style: GoogleFonts.teko(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
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
                color: Colors.tealAccent,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // The below code is for Time
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 10,
                            margin: EdgeInsets.only(
                              left: 30,
                              right: 30,
                              top: 20,
                              bottom: 5,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.tealAccent.shade400,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "UK    ",
                                  style: GoogleFonts.teko(
                                    color: Colors.black,
                                    fontSize: 40,
                                  ),
                                ),
                                BlinkText(
                                  _utcTimeString,
                                  style: GoogleFonts.teko(
                                    color: Colors.black,
                                    fontSize: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // The below code is for gate status (UI and data part)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.tealAccent.shade400,
                                  Colors.tealAccent.shade200,
                                  Colors.tealAccent.shade100,
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Current Status  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.tealAccent.shade400,
                                    ),
                                    child: Center(
                                      child: getCurrentStatus() == "Raise"
                                          ? Text(
                                              "RAISED",
                                              style: GoogleFonts.teko(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                color: Colors.black,
                                                fontSize: 33,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Text(
                                              "LOWERED",
                                              style: GoogleFonts.teko(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                                color: Colors.black,
                                                fontSize: 43,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //The below code is for what to do next (lower or raise)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.tealAccent.shade400,
                                  Colors.tealAccent.shade200,
                                  Colors.tealAccent.shade100,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: getCurrentStatus() == "Raise"
                                      ? Image(
                                          image: AssetImage(
                                              'assets/downarrow.gif'),
                                        )
                                      : Image(
                                          image:
                                              AssetImage('assets/arrowup.gif'),
                                        ),
                                ),
                                Container(
                                  child: getCurrentStatus() == "Raise"
                                      ? Text(
                                          'Lower in',
                                          style: GoogleFonts.teko(
                                            color: Colors.black,
                                            fontSize: 25,
                                          ),
                                        )
                                      : Text(
                                          'Raise in',
                                          style: GoogleFonts.teko(
                                            color: Colors.black,
                                            fontSize: 25,
                                          ),
                                        ),
                                ),
                                Container(
                                  child: Text(
                                    '${timeDiff.toString().substring(0, 7)}',
                                    style: GoogleFonts.teko(
                                      color: Colors.black,
                                      fontSize: 30,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // The below code is for the data shown from JSON file (UI and data part).
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.teal.shade300,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    height:
                                        MediaQuery.of(context).size.height / 12,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.arrow_left),
                                          Text(
                                            getWeekday(selectedDate) + "  :  ",
                                            style: GoogleFonts.teko(
                                              color: Colors.black,
                                              fontSize: 35,
                                            ),
                                          ),
                                          Text(
                                            selectedDate.day.toString(),
                                            style: GoogleFonts.teko(
                                              color: Colors.black,
                                              fontSize: 35,
                                            ),
                                          ),
                                          Text(
                                            '-',
                                            style: GoogleFonts.teko(
                                              color: Colors.black,
                                              fontSize: 35,
                                            ),
                                          ),
                                          Text(
                                            selectedDate.month.toString(),
                                            style: GoogleFonts.teko(
                                              color: Colors.black,
                                              fontSize: 35,
                                            ),
                                          ),
                                          Text(
                                            '-',
                                            style: GoogleFonts.teko(
                                              color: Colors.black,
                                              fontSize: 35,
                                            ),
                                          ),
                                          Text(
                                            selectedDate.year.toString(),
                                            style: GoogleFonts.teko(
                                              color: Colors.black,
                                              fontSize: 35,
                                            ),
                                          ),
                                          Icon(Icons.arrow_right),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: Divider(
                              height: 10,
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade200,
                                        Colors.blue.shade600
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _comapreTide(_items[
                                                        getDate(selectedDate)]
                                                    ["tide1"]) ==
                                                1
                                            ? Image(
                                                height: 50,
                                                width: 50,
                                                image: AssetImage(
                                                    'assets/hightide.png'))
                                            : _comapreTide(_items[getDate(
                                                            selectedDate)]
                                                        ["tide1"]) ==
                                                    2
                                                ? Image(
                                                    height: 50,
                                                    width: 50,
                                                    image: AssetImage(
                                                        'assets/lowtide.png'))
                                                : Icon(Icons.chat),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Tide Time : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["openTime1"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    "Gate Time : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["closeTime1"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Tide : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["tide1"] +
                                                        " m",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    "Gate : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["status1"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade200,
                                        Colors.blue.shade600
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _comapreTide(_items[
                                                        getDate(selectedDate)]
                                                    ["tide2"]) ==
                                                1
                                            ? Image(
                                                height: 50,
                                                width: 50,
                                                image: AssetImage(
                                                    'assets/hightide.png'))
                                            : _comapreTide(_items[getDate(
                                                            selectedDate)]
                                                        ["tide2"]) ==
                                                    2
                                                ? Image(
                                                    height: 50,
                                                    width: 50,
                                                    image: AssetImage(
                                                        'assets/lowtide.png'))
                                                : Icon(Icons.chat),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Tide Time : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["openTime2"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    "Gate Time : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["closeTime2"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Tide : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["tide2"] +
                                                        " m",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    "Gate : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["status2"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade200,
                                        Colors.blue.shade600
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _comapreTide(_items[
                                                        getDate(selectedDate)]
                                                    ["tide3"]) ==
                                                1
                                            ? Image(
                                                height: 50,
                                                width: 50,
                                                image: AssetImage(
                                                    'assets/hightide.png'))
                                            : _comapreTide(_items[getDate(
                                                            selectedDate)]
                                                        ["tide3"]) ==
                                                    2
                                                ? Image(
                                                    height: 50,
                                                    width: 50,
                                                    image: AssetImage(
                                                        'assets/lowtide.png'))
                                                : Icon(Icons.chat),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Tide Time : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["openTime3"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    "Gate Time : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["closeTime3"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Tide : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["tide3"] +
                                                        " m",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    "Gate : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["status3"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade200,
                                        Colors.blue.shade600
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _comapreTide(_items[
                                                        getDate(selectedDate)]
                                                    ["tide4"]) ==
                                                1
                                            ? Image(
                                                height: 50,
                                                width: 50,
                                                image: AssetImage(
                                                    'assets/hightide.png'))
                                            : _comapreTide(_items[getDate(
                                                            selectedDate)]
                                                        ["tide4"]) ==
                                                    2
                                                ? Image(
                                                    height: 50,
                                                    width: 50,
                                                    image: AssetImage(
                                                        'assets/lowtide.png'))
                                                : Icon(Icons.keyboard_control),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Tide Time : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["openTime4"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    "Gate Time : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["closeTime4"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Tide : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["tide4"] +
                                                        " m",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    "Gate : " +
                                                        _items[getDate(
                                                                selectedDate)]
                                                            ["status4"],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

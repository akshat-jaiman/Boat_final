import 'dart:async';

import 'package:boat/net/getdate.dart';
import 'package:flutter/material.dart';
import 'package:boat/net/dayData.dart';
import 'package:intl/intl.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  List<String> closeTimes = [];
  String timeValue = null;
  var timeDiff = null;
  var dateIndex = null;
  bool dateIncreasd = false;
  @override
  void initState() {
    super.initState();
    DateTime todayDate = DateTime.now();

    dateIndex = getDate(todayDate);
    getDateData();
    Timer.periodic(Duration(seconds: 1), (Timer t1) => {_getTime()});
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

    setState(() {
      var v = dateFormat.parse(timeValue);
      var currentTime = outputFormat.parse(outputFormat.format(DateTime.now()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(child: Text('Timer Screen ${timeDiff}')),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/services.dart';

Future<List<String>> dateData(int index) async {
  //print(index);
  String response = await rootBundle.loadString('assets/boatdata.json');
  final data = await json.decode(response);
  // print(index);
  // print(data["data"][index].runtimeType);
  final m = data["data"][index];
  List<String> closeTimes = [];
  m.forEach((key, value) => {
        if (key.contains('closeTime')) {closeTimes.add(value)}
      });

  //print(closeTimes);
  return closeTimes;
}

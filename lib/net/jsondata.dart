class JsonData {
  OpenTime openTime;
  CloseTime closeTime;
  Status status;
  Tide tide;
}

class OpenTime {
  String time1;
  String time2;
  String time3;
  String time4;
  String time5;

  OpenTime({this.time1, this.time2, this.time3, this.time4, this.time5});
}

class CloseTime {
  String time1;
  String time2;
  String time3;
  String time4;
  String time5;

  CloseTime({this.time1, this.time2, this.time3, this.time4, this.time5});
}

class Status {
  String status1;
  String status2;
  String status3;
  String status4;
  String status5;

  Status(
      {this.status1, this.status2, this.status3, this.status4, this.status5});
}

class Tide {
  String tide1;
  String tide2;
  String tide3;
  String tide4;
  String tide5;

  Tide({this.tide1, this.tide2, this.tide3, this.tide4, this.tide5});
}

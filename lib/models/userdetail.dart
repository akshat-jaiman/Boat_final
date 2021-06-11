import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String name;
  final String boatname;
  final String boattype;
  final String phone;
  final String address;

  UserData({this.name, this.boatname, this.boattype, this.phone, this.address});

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      name: doc['Name'],
      boatname: doc['BoatName'],
      boattype: doc['BoatType'],
      address: doc['Address'],
      phone: doc['PhoneNumber'],
    );
  }
}

import 'package:boat/models/userdetail.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final firestore = FirebaseFirestore.instance;
  var loggedinUser = FirebaseAuth.instance.currentUser;
  UserData currentUser;
  void _getUserName() async {
    var doc = await firestore.collection('users').doc(loggedinUser.uid).get();
    setState(() {
      currentUser = UserData.fromDocument(doc);
    });

    print(currentUser.boatname);
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(child: Text(currentUser.name)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(child: Text(currentUser.boatname)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(child: Text(currentUser.boattype)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(child: Text(currentUser.phone)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(child: Text(currentUser.address)),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

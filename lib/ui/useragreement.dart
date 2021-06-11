import 'package:boat/ui/bottomnavigation.dart';
import 'package:flutter/material.dart';

class UserAgreement extends StatefulWidget {
  UserAgreement({Key key}) : super(key: key);

  @override
  _UserAgreementState createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Agreement'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('User agreement'),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigation(),
                      ));
                },
                child: Text("Agree"))
          ],
        ),
      ),
    );
  }
}

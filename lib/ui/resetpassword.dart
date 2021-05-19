import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailField = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade200,
        appBar: AppBar(
          title: Text('Reset Password'),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.blue.shade200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  controller: _emailField,
                  decoration: InputDecoration(
                    hintText: "Enter Email Id",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 25),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: MaterialButton(
                    onPressed: () {
                      auth.sendPasswordResetEmail(email: _emailField.text);
                      print('Email sent to ');
                      print(_emailField.text);

                      Navigator.pop(context);
                    },
                    child: Text("Reset")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

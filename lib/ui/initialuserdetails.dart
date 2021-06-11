import 'package:boat/net/flutterfire.dart';
import 'package:boat/ui/useragreement.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class InitialUserDetails extends StatefulWidget {
  InitialUserDetails({Key key}) : super(key: key);

  @override
  _InitialUserDetailsState createState() => _InitialUserDetailsState();
}

class _InitialUserDetailsState extends State<InitialUserDetails> {
  TextEditingController _userName = new TextEditingController();
  TextEditingController _boatName = new TextEditingController();
  TextEditingController _boatType = new TextEditingController();
  TextEditingController _phoneNumber = new TextEditingController();
  TextEditingController _address = new TextEditingController();

  void _showToast(String msg) {
    Toast.show(msg, context, duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.blue.shade200,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 25),
                RichText(
                  text: TextSpan(
                    text: 'Enter details',
                    style: GoogleFonts.portLligatSans(fontSize: 40),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    controller: _userName,
                    decoration: InputDecoration(
                      hintText: "Enter Name",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: "Name",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    controller: _boatName,
                    decoration: InputDecoration(
                      hintText: "Enter Boat Name",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: "Boat Name",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    controller: _boatType,
                    decoration: InputDecoration(
                      hintText: "Enter Boat Type",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: "Boat Type",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.white),
                    controller: _phoneNumber,
                    decoration: InputDecoration(
                      hintText: "Enter Phone Number",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    controller: _address,
                    decoration: InputDecoration(
                      hintText: "Enter Your Address",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: "Address",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      int shouldNavigate = await updateUserDetails(
                          _userName.text,
                          _boatName.text,
                          _boatType.text,
                          _phoneNumber.text,
                          _address.text);
                      if (shouldNavigate == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserAgreement(),
                          ),
                        );
                      } else {
                        _showToast("An error occured, please try again");
                      }
                    },
                    child: Text("Register"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

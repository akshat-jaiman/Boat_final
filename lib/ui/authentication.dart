import 'package:boat/net/flutterfire.dart';
import 'package:boat/ui/homepage.dart';
import 'package:boat/ui/resetpassword.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showToast(String msg) {
    Toast.show(msg, context, duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Gate Time App',
                    style: GoogleFonts.portLligatSans(fontSize: 40),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                RichText(
                  text: TextSpan(
                    text: 'Conwy Marina',
                    style: GoogleFonts.portLligatSans(fontSize: 40),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                RichText(
                  text: TextSpan(text: 'Login/Register'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
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
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    children: [
                      TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(color: Colors.white),
                        controller: _passwordField,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _toggle();
                                });
                              }),
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          int shouldNavigate = await register(
                              _emailField.text, _passwordField.text);
                          if (shouldNavigate == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          } else if (shouldNavigate == 2) {
                            _showToast('Password provided is too weak');
                          } else if (shouldNavigate == 3) {
                            _showToast('Account already exists');
                          } else if (shouldNavigate == 4) {
                            _showToast('Invalid Email');
                          } else if (shouldNavigate == 5) {
                            _showToast(
                                'Registeration Failed, Please try again');
                          }
                        },
                        child: Text("Register"),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 35),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      child: MaterialButton(
                          onPressed: () async {
                            int shouldNavigate = await signIn(
                                _emailField.text, _passwordField.text);
                            if (shouldNavigate == 1) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('email', 'userid');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } else if (shouldNavigate == 2) {
                              _showToast('User Does not exist');
                            } else if (shouldNavigate == 3) {
                              _showToast('Invalid Email or Password');
                            } else if (shouldNavigate == 4) {
                              _showToast('Invalid Email');
                            } else if (shouldNavigate == 5) {
                              _showToast('Login Failed, Please try again');
                            }
                          },
                          child: Text("Login")),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                ElevatedButton(
                  onPressed: () {
                    print('home page pe jayega');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPassword(),
                      ),
                    );
                  },
                  child: Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

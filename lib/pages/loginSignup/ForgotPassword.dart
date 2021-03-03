import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/services/getData.dart';
import 'package:mart/services/request.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email, otp, pass, rPass;

  int flag = 0;

  final GlobalKey<ScaffoldState> forgotPassword =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (flag > 0) {
          setState(() {
            flag--;
          });
        } else {
          Navigator.pop(context);
        }
        return await false;
      },
      child: Scaffold(
        key: forgotPassword,
        appBar: CustomAppBar(context: context, title: "Forgot Password"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: flag == 0,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        Data.otp != "email"
                            ? "Enter your mobile number:"
                            : "Enter your email:",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        labelText:
                            Data.otp != "email" ? "Mobile number" : 'Email',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: FlatButton(
                        color: kBlue,
                        onPressed: () {
                          sendOTP();
                        },
                        child: Text(
                          "Get OTP",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: flag == 1,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        Data.otp != "email"
                            ? "Enter OTP from mobile number:"
                            : "Enter OTP from email:",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        otp = value;
                      },
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        labelText: 'OTP',
                      ),
                      maxLength: 4,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: FlatButton(
                        color: kBlue,
                        onPressed: () {
                          checkOTP();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: flag == 2,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Enter new password:",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        pass = value;
                      },
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        labelText: 'Enter password',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        rPass = value;
                      },
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(),
                        labelText: 'Re-enter password',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: FlatButton(
                        color: kBlue,
                        onPressed: () {
                          if (pass != rPass) {
                            forgotPassword.currentState.showSnackBar(SnackBar(
                              content:
                                  Text("Enter correct password in both fields"),
                            ));
                          } else {
                            changePassword();
                          }
                        },
                        child: Text(
                          "Change Password",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendOTP() async {
    var responseBody;
    Map<String, String> body = {"email": email, "custom_data": "sendotp"};
    responseBody = await postRequest("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "failed") {
        forgotPassword.currentState.showSnackBar(SnackBar(
          content: Text(responseBody['message']),
        ));
      } else {
        forgotPassword.currentState.showSnackBar(SnackBar(
          content: Text("OTP send!!!"),
        ));
        setState(() {
          flag = 1;
        });
      }
    }
  }

  Future<void> checkOTP() async {
    var responseBody;
    Map<String, String> body = {
      "email": email,
      "otp": otp,
      "custom_data": "checkotp"
    };
    responseBody = await postRequest("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "failed") {
        forgotPassword.currentState.showSnackBar(SnackBar(
          content: Text(responseBody['message']),
        ));
      } else {
        forgotPassword.currentState.showSnackBar(SnackBar(
          content: Text("OTP matched"),
        ));
        setState(() {
          flag = 2;
        });
      }
    }
  }

  Future<void> changePassword() async {
    var responseBody;
    Map<String, String> body = {
      "email": email,
      "updatePassword": pass,
      "custom_data": "updatepassword"
    };
    responseBody = await postRequest("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "failed") {
        forgotPassword.currentState.showSnackBar(SnackBar(
          content: Text(responseBody['message']),
        ));
      } else {
        forgotPassword.currentState.showSnackBar(SnackBar(
          content: Text("Password changed!!"),
        ));
        Future.delayed(Duration(milliseconds: 800), () {
          Navigator.pop(context);
        });
      }
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/pages/loginSignup/ForgotPassword.dart';
import 'package:mart/pages/loginSignup/SignUp.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  String phno, pass;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(title: "Login", context: context),
        body: Container(
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: pageHeading,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: TextField(
                      onChanged: (value) {
                        phno = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mobile Number',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: TextField(
                      onChanged: (value) {
                        pass = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                    child: FlatButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () async {
                          if (phno == null || pass == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Every data in every fields"),
                            ));
                          } else {
                            String temp = await login(context);
                            if (temp == "Login done!") {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pop(context);
                              });
                            }
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(temp),
                            ));
                          }
                        },
                        child: Text(
                          "Login",
                          style: buttonHeading,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: kBlue),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height - 125,
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "New user?",
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        children: [
                          Text(
                            "Click here to ",
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: Text(
                              "sign up",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kBlue,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  var responseBody;

  Future<String> login(BuildContext context) async {
    Map<String, String> body = {
      "custom_data": "verifycustomerlogin",
      "customerPassword": pass,
      "customerMobileNumber": phno
    };
    responseBody = await postRequest("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "failed") {
        return responseBody['errormessage'];
      } else {
        Provider.of<User>(context, listen: false)
            .storeUserId(responseBody['customer_id']);
        return "Login done!";
      }
    }
  }
}

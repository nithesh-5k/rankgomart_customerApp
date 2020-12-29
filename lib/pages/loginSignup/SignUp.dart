import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  String uname, pass, email, phno, cPass;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    AppBar bar = CustomAppBar(title: "Sign up", context: context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: bar,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Sign up",
                  style: pageHeading,
                ),
                SizedBox(
                  height: 20,
                ),
                buildTextField(
                    title: "Username", variable: (value) => uname = value),
                buildTextField(
                    title: "Mobile number",
                    variable: (value) => phno = value,
                    keyboard: TextInputType.phone),
                buildTextField(
                    title: "Email id", variable: (value) => email = value),
                buildTextField(
                    title: "Password",
                    variable: (value) => pass = value,
                    obscureText: true),
                buildTextField(
                    title: "Confirm Password",
                    variable: (value) => cPass = value,
                    obscureText: true),
                Container(
                  child: FlatButton(
                      color: Theme.of(context).accentColor,
                      onPressed: () async {
                        if (pass != cPass) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content:
                                Text("Enter correct password in both fields!!"),
                          ));
                        } else {
                          if (uname == null || phno == null || pass == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Every data in every fields"),
                            ));
                          } else {
                            String temp = await signUp(context);
                            if (temp == "Sucessfully registered") {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            }
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(temp),
                            ));
                          }
                        }
                      },
                      child: Text(
                        "Create account",
                        style: buttonHeading,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  var responseBody;

  Future<String> signUp(BuildContext context) async {
    Map<String, String> body = {
      "custom_data": "registeruser",
      "customerName": uname,
      "customerPassword": pass,
      "customerMobileNumber": phno,
      "customerEmailId": email ?? ""
    };
    responseBody = await postRequest("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "failed") {
        return responseBody['errormessage'];
      } else {
        Provider.of<User>(context, listen: false)
            .storeUserId(responseBody['customer_id'].toString());
        return "Sucessfully registered";
      }
    }
  }

  Widget buildTextField(
      {String title,
      Function variable,
      bool obscureText = false,
      TextInputType keyboard}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        keyboardType: keyboard,
        obscureText: obscureText,
        onChanged: (value) {
          variable(value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: title,
        ),
      ),
    );
  }
}

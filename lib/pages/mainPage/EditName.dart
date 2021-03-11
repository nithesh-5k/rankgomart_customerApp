import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class EditName extends StatefulWidget {
  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  var userProvider;
  String name;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<User>(context, listen: false);
    name = userProvider.user.customerName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(context: context, title: "Edit Name"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter the name:"),
            TextFormField(
              initialValue: name,
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                // border: OutlineInputBorder(),
                labelText: 'User name',
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: FlatButton(
                color: kBlue,
                onPressed: () {
                  final alphabets = RegExp(r'^[a-zA-Z\s\.]+$');
                  if (!alphabets.hasMatch(name)) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Enter valid name!"),
                    ));
                  } else {
                    if (name.length != 0) {
                      changeName();
                    }
                  }
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
    );
  }

  void changeName() async {
    var responseBody;
    var userProvider = Provider.of<User>(context, listen: false);
    Map<String, String> body = {
      "custom_data": "updateuserdata",
      "userName": name,
      "userId": userProvider.userId
    };
    responseBody = await postRequest("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "failed") {
        return responseBody['errormessage'];
      } else {
        userProvider.getUserDetails();
        Navigator.pop(context);
      }
    }
  }
}

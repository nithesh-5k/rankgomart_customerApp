import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/pages/loginSignup/Login.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<User>(context);
    // int index = userProvider.addressIndex;
    return Scaffold(
      appBar: CustomAppBar(context: context, title: "My Account"),
      body: userProvider.checkLogin()
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login to access your account",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    color: kBlue,
                    child: Text(
                      "Click here",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                  ),
                ],
              ),
            )
          : Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customContainer(
                        heading: "Name", text: userProvider.user.customerName),
                    SizedBox(
                      height: 10,
                    ),
                    customContainer(
                        heading: "Mobile Number",
                        text: userProvider.user.customerMobileNumber),
                    SizedBox(
                      height: 10,
                    ),
                    customContainer(
                        heading: "Email",
                        text: userProvider.user.customerEmailId),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         CupertinoPageRoute(
                    //             builder: (context) => AddressPage()));
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.all(10),
                    //     height: userProvider.addressId != null ? 130 : 70,
                    //     width: MediaQuery.of(context).size.width -
                    //         (MediaQuery.of(context).size.width / 3),
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.grey),
                    //         borderRadius: BorderRadius.circular(5)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "Address",
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 18),
                    //             ),
                    //             userProvider.addressId != null
                    //                 ? Column(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Text(userProvider
                    //                           .user
                    //                           .addresses[index]
                    //                           .customerAddress),
                    //                       Text(userProvider.user
                    //                           .addresses[index].customerCityId),
                    //                       Text(userProvider
                    //                           .user
                    //                           .addresses[index]
                    //                           .customerStateId),
                    //                       Text(userProvider
                    //                           .user
                    //                           .addresses[index]
                    //                           .customerCountryId),
                    //                       Text(userProvider.user
                    //                           .addresses[index].customerPincode)
                    //                     ],
                    //                   )
                    //                 : SizedBox()
                    //           ],
                    //         ),
                    //         Icon(Icons.arrow_forward_ios_outlined)
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    FlatButton(
                      onPressed: () {
                        showAlertDialog(context, () {
                          userProvider.deleteUserId();
                        });
                      },
                      child: Text(
                        "Sign out",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: kBlue,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  showAlertDialog(BuildContext context, Function signout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert!"),
          content: Text("Would you like to continue to sign out?"),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Continue"),
              onPressed: () {
                signout();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget customContainer({String heading, String text}) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 70,
      width: MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width / 3),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading ?? "",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            text ?? "",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class AddressPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<User>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Address",
          style: TextStyle(color: kBlue),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: ListView.builder(
          // itemCount: userProvider.user.addresses.length,
          itemCount: 0,
          itemBuilder: (context, index) {
            return Column(
              children: [
                // InkWell(
                //   onTap: () {
                //     _scaffoldKey.currentState.showSnackBar(SnackBar(
                //       content: Text("Address for delivery is selected"),
                //     ));
                //     userProvider.setAddressId(
                //         userProvider.user.addresses[index].customerAddressId,
                //         index);
                //     Future.delayed(Duration(milliseconds: 900), () {
                //       Navigator.pop(context);
                //     });
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(10),
                //     width: MediaQuery.of(context).size.width,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //             userProvider.user.addresses[index].customerAddress),
                //         Text(userProvider.user.addresses[index].customerCityId),
                //         Text(
                //             userProvider.user.addresses[index].customerStateId),
                //         Text(userProvider
                //             .user.addresses[index].customerCountryId),
                //         Text(
                //             userProvider.user.addresses[index].customerPincode),
                //       ],
                //     ),
                //   ),
                // ),
                Divider()
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => AddAddress()));
        },
      ),
    );
  }
}

class AddAddress extends StatelessWidget {
  String address,
      city = "6197",
      state = "753",
      country = "100",
      pincode = "630551";

  //TODO : not used as of now
  bool flag = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Add Address",
          style: TextStyle(color: kBlue),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            buildTextField(
                title: "Address", variable: (value) => address = value),
            buildTextField(title: "Sivagangai", readOnly: false),
            buildTextField(title: "Tamilnadu", readOnly: false),
            buildTextField(title: "India", readOnly: false),
            buildTextField(title: "630551", readOnly: false),
            SizedBox(
              height: 20,
            ),
            Container(
              child: FlatButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    if (flag) {
                      if (address == null ||
                          city == null ||
                          state == null ||
                          country == null ||
                          pincode == null) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Every data in every fields"),
                        ));
                      } else {
                        flag = false;
                        String temp = await addAddress(context);
                        if (temp == "Sucessfully added") {
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        } else {
                          flag = true;
                        }
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(temp),
                        ));
                      }
                    }
                  },
                  child: Text(
                    "Create address",
                    style: buttonHeading,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      {String title,
      Function variable,
      bool obscureText = false,
      bool readOnly = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: TextField(
        enabled: readOnly,
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

  var responseBody;

  Future<String> addAddress(BuildContext context) async {
    var userProvider = Provider.of<User>(context, listen: false);
    Map<String, String> body = {
      "custom_data": "addaddress",
      "customerId": userProvider.userId,
      "customerAddress": address,
      "customerCountryId": country,
      "customerStateId": state,
      "customerCityId": city,
      "customerPincode": pincode
    };
    responseBody = await postRequest("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "failed") {
        return responseBody['errormessage'];
      } else {
        userProvider.getUserDetails();
        return "Sucessfully added";
      }
    }
  }
}

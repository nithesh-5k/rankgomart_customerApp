import 'package:flutter/cupertino.dart';
import 'package:mart/model/UserModel.dart';
import 'package:mart/services/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier {
  UserModel user;
  String userId;
  // String addressId;
  // int addressIndex;

  Future<void> storeUserId(String id) async {
    userId = id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", id);
    notifyListeners();
    if (id != null) {
      getUserDetails();
    } else {
      user = null;
    }
  }

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = (prefs.getString("userId") ?? null);
    if (userId != null) {
      getUserDetails();
    }
  }

  Future<void> deleteUserId() async {
    storeUserId(null);
  }

  bool checkLogin() {
    return userId == null;
  }

  Future<void> getUserDetails() async {
    var responseBody;
    // addressIndex = null;
    // addressId = null;
    Map<String, String> body = {
      "custom_data": "getcustomerdetails",
      "customerId": userId
    };
    responseBody = await postRequest("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      user = UserModel.fromJson(responseBody['customerDetails']);
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getUserDetails();
      });
    }
    notifyListeners();
  }

  // void setAddressId(String id, int index) {
  //   addressId = id;
  //   addressIndex = index;
  //   notifyListeners();
  // }
}

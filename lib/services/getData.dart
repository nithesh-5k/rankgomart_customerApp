import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mart/apiLink.dart';
import 'package:mart/const.dart';
import 'package:mart/services/request.dart';

class Data {
  static String otp,
      paginationLimit,
      paginationStart,
      distancePrice,
      minKm,
      maxKm,
      upiID,
      serviceError,
      message,
      paymentMsg;

  static getAPIData() async {
    var responseBody;
    Map<String, String> body = {"custom_data": "getapidata"};
    responseBody = await postRequest1(body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "failed") {
        return responseBody['errormessage'];
      } else {
        print(responseBody);
        var data = responseBody["dataDetails"];
        print(data.runtimeType);
        data.forEach((element) {
          for (var key in element.keys) {
            // print("$key + ${element[key]}");
            if (element[key] == "Project Link") {
              BASE_URL = element["dataValue"];
            }
            if (element[key] == "Minimum km") {
              minKm = element["dataValue"];
            }
            if (element[key] == "km/charge") {
              distancePrice = element["dataValue"];
            }
            if (element[key] == "Pagination Start") {
              paginationStart = element["dataValue"];
            }
            if (element[key] == "Pagination Limit") {
              paginationLimit = element["dataValue"];
            }
            if (element[key] == "Otp Check") {
              otp = element["dataValue"];
            }
            if (element[key] == "Maximun km") {
              maxKm = element["dataValue"];
            }
            if (element[key] == "UPI id") {
              upiID = element["dataValue"];
            }
            if (element[key] == "Service Error") {
              serviceError = element["dataValue"];
            }
            if (element[key] == "Message") {
              message = element["dataValue"];
            }
            if (element[key] == "Payment msg") {
              paymentMsg = element["dataValue"];
            }
          }
        });
      }
    }
  }
}

Future<Map<String, dynamic>> postRequest1(body) async {
  print(initialLink);
  print(body);
  final http.Response response =
      await http.post(initialLink, body: json.encode(body)).timeout(
          Duration(
            seconds: 20,
          ), onTimeout: () {
    return Future.value(http.Response(json.encode(timeoutResponse()), 400));
  }).catchError((error) {
    return Future.value(http.Response(json.encode(errorResponse()), 400));
  });
  Map<String, dynamic> responseBody = json.decode(response.body);
  if (response.statusCode < 300 && response.statusCode >= 200) {
    responseBody.putIfAbsent("success", () => true);
  }
  print(responseBody);
  return responseBody;
}

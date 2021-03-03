import 'package:flutter/material.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/BakeryCard.dart';
import 'package:mart/model/Bakery.dart';
import 'package:mart/services/getData.dart';
import 'package:mart/services/request.dart';

class BakeryMainPage extends StatefulWidget {
  @override
  _BakeryMainPageState createState() => _BakeryMainPageState();
}

class _BakeryMainPageState extends State<BakeryMainPage> {
  List<Bakery> bakeries;

  var responseBody;

  Future<void> getBakeries() async {
    Map<String, String> body = {"custom_data": "getbakerylist"};
    responseBody = await postRequestForList("API/bakery_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      setState(() {
        bakeries = bakeriesFromJson(responseBody['items']['bakerylist']);
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getBakeries();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initialCalls();
  }

  Future<void> initialCalls() async {
    if (BASE_URL == null) {
      await Data.getAPIData();
    }
    getBakeries();
  }

  @override
  Widget build(BuildContext context) {
    return responseBody == null
        ? Center(child: CircularProgressIndicator())
        : GridView.count(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(5),
            crossAxisCount: 2,
            children: List.generate(bakeries.length, (index) {
              return BakeryCard(
                bakery: bakeries[index],
              );
            }),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:mart/customWidgets/HotelCard.dart';
import 'package:mart/model/Hotel.dart';
import 'package:mart/services/request.dart';

class HotelMainPage extends StatefulWidget {
  @override
  _HotelMainPageState createState() => _HotelMainPageState();
}

class _HotelMainPageState extends State<HotelMainPage> {
  List<Hotel> hotels;

  var responseBody;

  Future<void> getHotels() async {
    Map<String, String> body = {"custom_data": "gethotellist"};
    responseBody = await postRequestForList("API/hotel_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      setState(() {
        hotels = categoriesFromJson(responseBody['items']['hotellist']);
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getHotels();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHotels();
  }

  @override
  Widget build(BuildContext context) {
    return responseBody == null
        ? Center(child: CircularProgressIndicator())
        : GridView.count(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(5),
            crossAxisCount: 2,
            children: List.generate(hotels.length, (index) {
              return HotelCard(
                hotel: hotels[index],
              );
            }),
          );
  }
}

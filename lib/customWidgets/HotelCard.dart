import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mart/const.dart';
import 'package:mart/model/Hotel.dart';
import 'package:mart/pages/food/foodListingPage.dart';

class HotelCard extends StatelessWidget {
  Hotel hotel;

  HotelCard({this.hotel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => FoodListingPage(hotel)));
      },
      child: Container(
        padding: EdgeInsets.all(3),
        margin: EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 5),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                spreadRadius: 0,
              )
            ]),
        child: Column(
          children: [
            Expanded(
                child: Image.network(
              BASE_URL + hotel.sellerHotelImage,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                return preLoaderImage(
                    child: child, loadingProgress: loadingProgress);
              },
            )),
            SizedBox(
              height: 10,
            ),
            Text(
              hotel.sellerHotelName,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

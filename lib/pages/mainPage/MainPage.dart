import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomFAB.dart';
import 'package:mart/pages/bakery/bakeryMainPage.dart';
import 'package:mart/pages/food/hotelMainPage.dart';
import 'package:mart/pages/groceries/mainPage.dart';
import 'package:mart/pages/mainPage/SideDrawer.dart';
import 'package:mart/pages/mainPage/userProfile.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

enum Type { food, meat, cake, grocery }

class _MainPageState extends State<MainPage> {
  Type currentType = Type.grocery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.blue),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.notifications,
          //     color: kLightBlack,
          //   ),
          //   onPressed: () {
          //     print(Provider.of<User>(context, listen: false).userId);
          //     //TODO: not required as of now
          //   },
          // ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: kLightBlack,
            ),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => UserProfile()));
            },
          ),
        ],
        title: Image.asset("assets/logo.png"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            height: 60,
            color: kGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: menuItem(
                        currentType == Type.food
                            ? "Order Grocery"
                            : "Order Food", () {
                  setState(() {
                    if (currentType == Type.food) {
                      currentType = Type.grocery;
                    } else {
                      currentType = Type.food;
                    }
                  });
                })),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: menuItem(
                        currentType == Type.cake
                            ? "Order Grocery"
                            : "Order Cake", () {
                  setState(() {
                    if (currentType == Type.cake) {
                      currentType = Type.grocery;
                    } else {
                      currentType = Type.cake;
                    }
                  });
                })),
                SizedBox(
                  width: 5,
                ),
                // Expanded(child: menuItem("Order Meat", () {})),
              ],
            ),
          ),
          Expanded(
            child: currentType == Type.grocery
                ? GroceriesMainPage()
                : currentType == Type.food
                    ? HotelMainPage()
                    : BakeryMainPage(),
          ),
        ],
      ),
      drawer: SideDrawer(),
      floatingActionButton: CustomFAB(),
    );
  }

  Widget menuItem(String text, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.blueAccent)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

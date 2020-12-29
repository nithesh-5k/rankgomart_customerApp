import 'package:flutter/material.dart';
import 'package:mart/pages/mainPage/MainPage.dart';
import 'package:mart/provider/cart.dart';
import 'package:mart/provider/gps.dart';
import 'package:mart/provider/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => User(),
        ),
        ChangeNotifierProvider(
          create: (context) => GPS(),
        ),
      ],
      child: MaterialApp(
        home: MainPage(),
      ),
    );
  }
}

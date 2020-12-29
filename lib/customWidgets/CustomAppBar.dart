import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar CustomAppBar({String title, @required BuildContext context}) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.blue),
    titleSpacing: 0,
    leading: null,
    title: Row(
      children: [
        Transform.translate(
          offset: Offset(-10, 0),
          child: IconButton(
              icon: Icon(Icons.home_rounded),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              }),
        ),
        Transform.translate(
          offset: Offset(-10, 0),
          child: Text(
            title,
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.white,
  );
}

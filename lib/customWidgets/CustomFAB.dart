import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mart/pages/mainPage/cartPage.dart';
import 'package:mart/provider/cart.dart';
import 'package:provider/provider.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => CartPage()));
      },
      child: Container(
        height: 38,
        width: 38,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.shopping_cart),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 15,
                width: 15,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                child: Center(
                  child: Text(
                    Provider.of<Cart>(context).productCount.toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

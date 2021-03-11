import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/pages/loginSignup/Login.dart';
import 'package:mart/pages/mainPage/orderPage.dart';
import 'package:mart/provider/cart.dart';
import 'package:mart/provider/user.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<Cart>(context);
    var cartProviderLF = Provider.of<Cart>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: "My Cart", context: context),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: cartProvider.productCount,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: Row(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 3 -
                                      20,
                                  child: Image.network(
                                    BASE_URL +
                                        cartProvider
                                            .cartProducts[index].imageUrl,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      return preLoaderImage(
                                          child: child,
                                          loadingProgress: loadingProgress);
                                    },
                                  )),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(cartProvider
                                              .cartProducts[index].name),
                                          Row(
                                            children: [
                                              Text(
                                                  "Rs.${cartProvider.cartProducts[index].salePrice}"),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              cartProvider.cartProducts[index]
                                                          .mrpPrice !=
                                                      null
                                                  ? Text(
                                                      "Rs.${cartProvider.cartProducts[index].mrpPrice}",
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        deleteIcon(cartProviderLF, index),
                                        Column(
                                          children: [
                                            measureQuantity(cartProviderLF,
                                                index, cartProvider),
                                            Text(
                                                "Price: ${(double.parse(cartProvider.cartProducts[index].salePrice) * cartProvider.quantity[index]).toStringAsFixed(2)}"),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider()
                      ],
                    );
                  }),
            ),
          ),
          Container(
            height: 60,
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                            "Total Price: ${cartProvider.totalPrice().toStringAsFixed(2)}"))),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (cartProviderLF.totalPrice() > 0) {
                        if (Provider.of<User>(context, listen: false)
                            .checkLogin()) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Login to checkout"),
                            duration: Duration(milliseconds: 500),
                          ));
                          Future.delayed(Duration(milliseconds: 500), () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => LoginScreen()));
                          });
                        } else {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => OrderPage()));
                        }
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Add products to proceed"),
                        ));
                      }
                    },
                    child: Container(
                      color: kBlue,
                      child: Center(
                          child: Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row measureQuantity(Cart cartProviderLF, int index, Cart cartProvider) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            cartProviderLF.decrementQuantity(index);
          },
          child: Container(
            color: Colors.grey[400],
            height: 20,
            width: 20,
            child: Center(
              child: Text(
                "-",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cartProvider.quantity[index].toString()),
        ),
        InkWell(
          onTap: () {
            cartProviderLF.incrementQuantity(index);
          },
          child: Container(
            color: Colors.grey[400],
            height: 20,
            width: 20,
            child: Center(
              child: Text(
                "+",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }

  IconButton deleteIcon(Cart cartProviderLF, int index) {
    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          cartProviderLF.deleteProduct(index);
        });
  }
}

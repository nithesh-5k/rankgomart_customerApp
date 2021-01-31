import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mart/const.dart';
import 'package:mart/pages/mainPage/MainPage.dart';
import 'package:mart/pages/mainPage/userProfile.dart';
import 'package:mart/provider/cart.dart';
import 'package:mart/provider/gps.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';
import 'package:upi_india/upi_india.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

enum Payment { gpay, cod }

class _OrderPageState extends State<OrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int distance, distancePrice;
  bool flag = true;

  UpiIndia _upiIndia = UpiIndia();
  UpiResponse _transaction;

  Future<void> calculateDistance() async {
    distance =
        await Provider.of<GPS>(context, listen: false).calculateDistance();
    setState(() {
      flag = false;
    });
  }

  AppBar bar = AppBar(
    title: Text(
      "Order now",
      style: TextStyle(color: kBlue),
    ),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.blue),
  );
  Payment selected = Payment.cod;
  bool placeOrderFlag = true,
      fakePlaceOrder = true,
      distanceRejected = false,
      callOnceFlag = false;

  //TODO
  bool forceFlag = true;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<User>(context);
    if (flag) {
      calculateDistance();
    } else {
      if (forceFlag) {
        if (distance <= 4) {
          distancePrice = 0;
        } else {
          if (distance > 4 && distance <= 10) {
            distancePrice = (distance - 4) * 10;
          } else {
            distanceRejected = true;
          }
        }
      }
    }
    return distanceRejected
        ? Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        //TODO
                        distancePrice = distance * 10;
                        distanceRejected = false;
                        forceFlag = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: EdgeInsets.only(
                          top: 30, left: 10, right: 10, bottom: 30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Sorry! This order cannot be placed at this location.",
                        style: kHeading,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: kBlue, borderRadius: BorderRadius.circular(5)),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Center(
                        child: Text(
                          "Get back to Home Screen",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : flag
            ? Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Calculating distance")
                    ],
                  ),
                ),
              )
            : Scaffold(
                key: _scaffoldKey,
                appBar: bar,
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 20,
                      child: Container(
                        height: MediaQuery.of(context).size.height -
                            110 -
                            bar.preferredSize.height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 40,
                                padding: EdgeInsets.only(
                                    top: 20, left: 10, right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "User details",
                                          style: kHeading,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        UserProfile()));
                                          },
                                          child: Container(
                                            child: Text(
                                              "Go to account",
                                              style: TextStyle(color: kBlue),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Name:",
                                      style: kSideHeading,
                                    ),
                                    Text("\t" * 3 +
                                        userProvider.user.customerName),
                                    Text(
                                      "Mobile number:",
                                      style: kSideHeading,
                                    ),
                                    Text("\t" * 3 +
                                        userProvider.user.customerMobileNumber),
                                    Text(
                                      "Email:",
                                      style: kSideHeading,
                                    ),
                                    Text("\t" * 3 +
                                        userProvider.user.customerEmailId),
                                    Text(
                                      "Address:",
                                      style: kSideHeading,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("\t" * 3 +
                                            Provider.of<GPS>(context).street),
                                        Text("\t" * 3 + "Sivagangai"),
                                        Text("\t" * 3 + "Tamilnadu")
                                      ],
                                    ),
                                    // InkWell(
                                    //     onTap: () {
                                    //       Navigator.push(
                                    //           context,
                                    //           CupertinoPageRoute(
                                    //               builder: (context) =>
                                    //                   AddressPage()));
                                    //     },
                                    //     child: Container(
                                    //         height: 40,
                                    //         child: Center(
                                    //           child: Text(
                                    //             "\t" * 3 + "Select address",
                                    //             style: TextStyle(color: kBlue),
                                    //           ),
                                    //         )))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 40,
                                padding: EdgeInsets.only(
                                    top: 20, left: 10, right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payment options",
                                      style: kHeading,
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: Payment.cod,
                                          groupValue: selected,
                                          onChanged: (Payment value) {
                                            setState(() {
                                              selected = value;
                                            });
                                          },
                                        ),
                                        Text("Cash on delivery")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: Payment.gpay,
                                          groupValue: selected,
                                          onChanged: (Payment value) {
                                            setState(() {
                                              selected = value;
                                            });
                                          },
                                        ),
                                        Text("Google pay")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 40,
                                padding: EdgeInsets.only(
                                    top: 20, left: 10, right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Price",
                                      style: kHeading,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Text("Items")),
                                        Expanded(
                                          child: Text("Rs." +
                                              Provider.of<Cart>(context)
                                                  .totalPrice()
                                                  .toString()),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Text("Delivery")),
                                        Expanded(
                                          child: Text("Rs." +
                                              distancePrice.toString() +
                                              ".00"),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Text("Total")),
                                        Expanded(
                                          child: Text(
                                            "Rs." +
                                                (Provider.of<Cart>(context)
                                                            .totalPrice() +
                                                        distancePrice)
                                                    .toString(),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          if (placeOrderFlag) {
                            // if (userProvider.addressId == null) {
                            //   _scaffoldKey.currentState.showSnackBar(SnackBar(
                            //     content:
                            //         Text("Please, select address to proceed"),
                            //     duration: Duration(milliseconds: 500),
                            //   ));
                            // } else {
                            setState(() {
                              placeOrderFlag = false;
                              fakePlaceOrder = false;
                            });
                            callOnceFlag = true;
                            if (selected == Payment.gpay) {
                              startTransaction();
                            } else {
                              placeOrder(context);
                            }
                            // }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: kBlue,
                              borderRadius: BorderRadius.circular(5)),
                          height: 50,
                          width: MediaQuery.of(context).size.width - 40,
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Visibility(
                                    visible: !fakePlaceOrder,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.black12,
                                    )),
                                Text(
                                  selected == Payment.gpay
                                      ? "Pay and Place your order"
                                      : "Place your order",
                                  style: TextStyle(
                                      color: fakePlaceOrder
                                          ? Colors.white
                                          : Colors.grey,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  Future<void> startTransaction() async {
    try {
      _transaction = await initiateTransaction(UpiApp.googlePay);
      _checkTxnStatus(_transaction.status);
    } catch (e) {
      _upiErrorHandler(e.runtimeType);
    }
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: UpiApp.googlePay,
      receiverUpiId: "7708709733@okbizaxis",
      receiverName: 'RankgoMart',
      transactionRefId: 'Testing_UPI',
      transactionNote: 'Thanks for shopping at RankgoMart',
      amount: Provider.of<Cart>(context, listen: false).totalPrice() +
          distancePrice,
    );
  }

  void _upiErrorHandler(error) {
    setState(() {
      placeOrderFlag = true;
      fakePlaceOrder = true;
    });
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Google Pay app not installed on device'),
          duration: Duration(seconds: 2),
        ));
        break;
      case UpiIndiaUserCancelledException:
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('You cancelled the transaction'),
          duration: Duration(seconds: 2),
        ));
        break;
      case UpiIndiaNullResponseException:
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Google Pay app didn\'t return any response'),
          duration: Duration(seconds: 2),
        ));
        break;
      case UpiIndiaInvalidParametersException:
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Google Pay app cannot handle the transaction'),
          duration: Duration(seconds: 2),
        ));
        break;
      default:
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('An Unknown error has occurred. Try again!!!'),
          duration: Duration(seconds: 2),
        ));
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        placeOrder(context);
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        //TODO check for pending status
        break;
      case UpiPaymentStatus.FAILURE:
        setState(() {
          placeOrderFlag = true;
          fakePlaceOrder = true;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Transaction Failed. Try Again!!!'),
          duration: Duration(seconds: 2),
        ));
        print('Transaction Failed');
        break;
      default:
        setState(() {
          placeOrderFlag = true;
          fakePlaceOrder = true;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Received an Unknown transaction status. Try again!!!'),
          duration: Duration(seconds: 2),
        ));
        print('Received an Unknown transaction status');
    }
  }

  Future<void> placeOrder(BuildContext context) async {
    if (callOnceFlag) {
      callOnceFlag = false;
    } else {
      return;
    }
    var responseBody;
    Map<String, dynamic> body;
    var cartProvider = Provider.of<Cart>(context, listen: false);
    if (cartProvider.type == Type.grocery) {
      body = placeGroceryOrder(context);
      responseBody = await postRequest("API/homepage_api.php", body);
    } else {
      if (cartProvider.type == Type.food) {
        body = placeHotelOrder(context);
        responseBody = await postRequest("API/hotel_api.php", body);
      } else {
        if (cartProvider.type == Type.cake) {
          body = placeBakeryOrder(context);
          responseBody = await postRequest("API/bakery_api.php", body);
        }
      }
    }
    if (responseBody['success'] == null
        ? false
        : responseBody['success'] && cartProvider.cartProducts.length > 0) {
      if (responseBody['appresponse'] == "failed") {
        setState(() {
          placeOrderFlag = true;
          fakePlaceOrder = true;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(responseBody['errormessage']),
          duration: Duration(milliseconds: 500),
        ));
      } else {
        setState(() {
          fakePlaceOrder = true;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Order placed!!!"),
          duration: Duration(seconds: 2),
        ));
        Future.delayed(Duration(seconds: 3), () {
          Navigator.popUntil(context, (route) => route.isFirst);
          Future.delayed(Duration(milliseconds: 500), () {
            cartProvider.clearCart();
          });
        });
      }
    }
  }

  Map<String, dynamic> placeGroceryOrder(BuildContext context) {
    var userProvider = Provider.of<User>(context, listen: false);
    var cartProvider = Provider.of<Cart>(context, listen: false);
    List<Map<String, String>> orders = [];
    for (int i = 0; i < cartProvider.cartProducts.length; i++) {
      orders.add({
        "customerProductRefId": cartProvider.cartProducts[i].id,
        "orderProductQuantity": cartProvider.quantity[i].toString(),
        "orderProductMrpPrice": cartProvider.cartProducts[i].mrpPrice,
        "orderProductSalePrice": cartProvider.cartProducts[i].salePrice
      });
    }
    Map<String, dynamic> body = {
      "custom_data": "addpaymentdetails",
      "transcation_no":
          selected == Payment.gpay ? _transaction.transactionId : "",
      "orderCustomerRefId": userProvider.userId,
      "customerAddressRefId": [
        {
          "customerAddress": Provider.of<GPS>(context, listen: false).street,
          "customerCountryId": "6197",
          "customerStateId": "753",
          "customerCityId": "100",
          "customerPincode": "630551"
        }
      ],
      "paymentMode": selected == Payment.gpay ? "GooglePay" : "cod",
      "paidStatus": selected == Payment.gpay ? "paid" : "unpaid",
      "totalCartAmount": cartProvider.totalPrice(),
      "orderDeliveryCharge": distancePrice.toString(),
      "totalOrderAmount": cartProvider.totalPrice() + distancePrice,
      "groceryShoppingCart": orders
    };
    return body;
  }

  Map<String, dynamic> placeHotelOrder(BuildContext context) {
    var userProvider = Provider.of<User>(context, listen: false);
    var cartProvider = Provider.of<Cart>(context, listen: false);
    List<Map<String, String>> orders = [];
    for (int i = 0; i < cartProvider.cartProducts.length; i++) {
      orders.add({
        "customerProductRefId": cartProvider.cartProducts[i].id,
        "orderProductQuantity": cartProvider.quantity[i].toString(),
        "orderProductMrpPrice": cartProvider.cartProducts[i].mrpPrice,
        "orderProductSalePrice": cartProvider.cartProducts[i].salePrice
      });
    }
    Map<String, dynamic> body = {
      "custom_data": "checkoutdetails",
      "transcation_no":
          selected == Payment.gpay ? _transaction.transactionId : "",
      "hotelRefId": cartProvider.id,
      "orderCustomerRefId": userProvider.userId,
      "customerAddressRefId": [
        {
          "customerAddress": Provider.of<GPS>(context, listen: false).street,
          "customerCountryId": "6197",
          "customerStateId": "753",
          "customerCityId": "100",
          "customerPincode": "630551"
        }
      ],
      "paymentMode": selected == Payment.gpay ? "GooglePay" : "cod",
      "paidStatus": selected == Payment.gpay ? "paid" : "unpaid",
      "totalCartAmount": cartProvider.totalPrice(),
      "orderDeliveryCharge": "",
      "totalOrderAmount": cartProvider.totalPrice(),
      "hotelShoppingCart": orders
    };
    return body;
  }

  Map<String, dynamic> placeBakeryOrder(BuildContext context) {
    var userProvider = Provider.of<User>(context, listen: false);
    var cartProvider = Provider.of<Cart>(context, listen: false);
    List<Map<String, String>> orders = [];
    for (int i = 0; i < cartProvider.cartProducts.length; i++) {
      orders.add({
        "customerProductRefId": cartProvider.cartProducts[i].id,
        "orderProductQuantity": cartProvider.quantity[i].toString(),
        "orderProductMrpPrice": cartProvider.cartProducts[i].mrpPrice,
        "orderProductSalePrice": cartProvider.cartProducts[i].salePrice
      });
    }
    Map<String, dynamic> body = {
      "custom_data": "bakerycheckoutdetails",
      "transcation_no":
          selected == Payment.gpay ? _transaction.transactionId : "",
      "bakeryRefId": cartProvider.id,
      "orderCustomerRefId": userProvider.userId,
      "customerAddressRefId": [
        {
          "customerAddress": Provider.of<GPS>(context, listen: false).street,
          "customerCountryId": "6197",
          "customerStateId": "753",
          "customerCityId": "100",
          "customerPincode": "630551"
        }
      ],
      "paymentMode": selected == Payment.gpay ? "GooglePay" : "cod",
      "paidStatus": selected == Payment.gpay ? "paid" : "unpaid",
      "totalCartAmount": cartProvider.totalPrice(),
      "orderDeliveryCharge": "",
      "totalOrderAmount": cartProvider.totalPrice(),
      "bakeryShoppingCart": orders
    };
    return body;
  }
}

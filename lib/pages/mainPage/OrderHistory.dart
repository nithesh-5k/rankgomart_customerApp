import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/model/order/BakeryOrder.dart';
import 'package:mart/model/order/GroceryOrder.dart';
import 'package:mart/model/order/HotelOrder.dart';
import 'package:mart/model/order/IOrder.dart';
import 'package:mart/model/order/orderItem/OrderIItem.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  var responseBody;
  List<IOrder> orders = [];

  Future<void> getOrders() async {
    Map<String, String> body = {
      "custom_data": "getcustomerorderlist",
      "customerId": Provider.of<User>(context, listen: false).userId,
    };
    responseBody = await postRequest("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['appresponse'] == "success") {
        var temp = responseBody['orderList'];
        if (mounted) {
          setState(() {
            for (int i = 0; i < temp.length; i++) {
              if (temp[i]['mainCategoryId'] == 1) {
                orders.add(GroceryOrder.fromJson(temp[i]));
              } else {
                if (temp[i]['mainCategoryId'] == 2) {
                  orders.add(HotelOrder.fromJson(temp[i]));
                } else {
                  if (temp[i]['mainCategoryId'] == 3) {
                    orders.add(BakeryOrder.fromJson(temp[i]));
                  }
                }
              }
            }
          });
        }
      }
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getOrders();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Order History", context: context),
      body: responseBody == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                return orderCard(orders[index], context);
              },
              itemCount: orders.length,
            ),
    );
  }

  Widget orderCard(IOrder order, BuildContext context) {
    Color buttonColor = Colors.lightBlue;
    String buttonText = "Order placed";
    if (order.orderCurrentStatus == "accepted") {
      buttonText = "Waiting for pickup";
      buttonColor = Colors.amber;
    } else {
      if (order.orderCurrentStatus == "picked") {
        buttonText = "Will be delivered";
        buttonColor = Colors.lightGreen;
      } else {
        if (order.orderCurrentStatus == "delivered") {
          buttonText = "Delivered";
          buttonColor = Colors.green;
        }
      }
    }
    return Container(
      height: order.mainCategoryId == 1.toString() ? 250 : 400,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          order.mainCategoryId == 1.toString()
              ? SizedBox()
              : Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height: 80, child: Image.network(order.image)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Ordered from ${order.locationName}")
                    ],
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      order.mainCategoryId == "1"
                          ? "Grocery Order ID"
                          : "Order ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(order.orderCode)
                  ],
                ),
              )
            ],
          ),
          FlatButton(
            color: kGreen,
            child: Center(
              child: Text(
                "ITEMS",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            onPressed: () {
              listItems(order.items, context);
            },
          ),
          Text(
            "Ordered On",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(order.orderCreatedDate),
          Text(
            "Total Amount",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(order.totalOrderAmount),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  buttonText,
                  style: TextStyle(color: Colors.white),
                ),
                color: buttonColor,
              )
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> listItems(List<OrderIItem> items, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Item Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[index].name),
                      Row(
                        children: [
                          Text(
                            "Quantity: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(items[index].quantity),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Total price:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              " Rs.${(double.parse(items[index].quantity)) * double.parse(items[index].price)}"),
                        ],
                      ),
                      Divider(),
                    ],
                  );
                },
                itemCount: items.length,
              ),
            ),
          );
        });
  }
}

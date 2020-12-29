import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/customWidgets/CustomFAB.dart';
import 'package:mart/model/Hotel.dart';
import 'package:mart/model/Item/FoodItem.dart';
import 'package:mart/pages/mainPage/MainPage.dart';
import 'package:mart/provider/cart.dart';
import 'package:mart/provider/gps.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class FoodListingPage extends StatefulWidget {
  Hotel hotel;

  FoodListingPage(this.hotel);

  @override
  _FoodListingPageState createState() => _FoodListingPageState();
}

class _FoodListingPageState extends State<FoodListingPage> {
  List<FoodItem> items;
  var responseBody;

  Future<void> getFoodItems() async {
    Map<String, String> body = {
      "custom_data": "gethotelitemlist",
      "hotelId": widget.hotel.sellerId
    };
    responseBody = await postRequestForList("API/hotel_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      setState(() {
        items = itemsFromJson(responseBody['items']['itemlist']);
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getFoodItems();
      });
    }
  }

  void initState() {
    super.initState();
    getFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(context: context, title: widget.hotel.sellerHotelName),
      body: responseBody == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                int countIndex = Provider.of<Cart>(context).getQuantity(
                    items[index].id, Type.food, widget.hotel.sellerId);
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                                height: 80,
                                width: 80,
                                child: Image.network(
                                    BASE_URL + items[index].imageUrl)),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(items[index].name),
                                      Text("Rs." + items[index].salePrice),
                                    ],
                                  ),
                                  Flexible(
                                    child: items[index]
                                                .productAvailableStatus ==
                                            "unavailable"
                                        ? Center(
                                            child: Text(
                                              "Not available now",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (Provider.of<Cart>(context,
                                                                  listen: false)
                                                              .type ==
                                                          Type.food &&
                                                      Provider.of<Cart>(context,
                                                                  listen: false)
                                                              .id ==
                                                          widget.hotel
                                                              .sellerId) if (Provider.of<
                                                                      Cart>(
                                                                  context,
                                                                  listen: false)
                                                              .quantity[
                                                          countIndex] ==
                                                      1) {
                                                    Provider.of<Cart>(context,
                                                            listen: false)
                                                        .deleteProduct(
                                                            countIndex);
                                                  } else {
                                                    Provider.of<Cart>(context,
                                                            listen: false)
                                                        .decrementQuantity(
                                                            countIndex);
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.grey[400],
                                                  height: 20,
                                                  width: 20,
                                                  child: Center(
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(countIndex == -1
                                                    ? "0"
                                                    : Provider.of<Cart>(context)
                                                        .quantity[countIndex]
                                                        .toString()),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Provider.of<Cart>(context,
                                                          listen: false)
                                                      .addFood(
                                                          items[index],
                                                          widget.hotel.sellerId,
                                                          context,
                                                          new LatLng(
                                                              latitude: widget
                                                                  .hotel
                                                                  .latitude,
                                                              longitude: widget
                                                                  .hotel
                                                                  .longitude));

                                                  setState(() {});
                                                },
                                                child: Container(
                                                  color: Colors.grey[400],
                                                  height: 20,
                                                  width: 20,
                                                  child: Center(
                                                    child: Text(
                                                      "+",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
              itemCount: items.length,
            ),
      floatingActionButton: CustomFAB(),
    );
  }
}

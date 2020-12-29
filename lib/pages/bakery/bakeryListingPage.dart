import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/customWidgets/CustomFAB.dart';
import 'package:mart/model/Bakery.dart';
import 'package:mart/model/Item/PastryItem.dart';
import 'package:mart/pages/mainPage/MainPage.dart';
import 'package:mart/provider/cart.dart';
import 'package:mart/provider/gps.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class BakeryListingPage extends StatefulWidget {
  Bakery bakery;

  BakeryListingPage(this.bakery);

  @override
  _BakeryListingPageState createState() => _BakeryListingPageState();
}

class _BakeryListingPageState extends State<BakeryListingPage> {
  List<PastryItem> items;
  var responseBody;

  Future<void> getFoodItems() async {
    Map<String, String> body = {
      "custom_data": "getbakeryitemlist",
      "bakeryId": widget.bakery.sellerId
    };
    responseBody = await postRequestForList("API/bakery_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      setState(() {
        items = pastriesFromJson(responseBody['items']['bakeryitemlist']);
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
          CustomAppBar(context: context, title: widget.bakery.sellerBakeryName),
      body: responseBody == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                int countIndex = Provider.of<Cart>(context).getQuantity(
                    items[index].id, Type.cake, widget.bakery.sellerId);
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                                  items[index].productAvailableStatus ==
                                          "unavailable"
                                      ? Center(
                                          child: Text(
                                            "Not available now",
                                            style: TextStyle(color: Colors.red),
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
                                                        Type.cake &&
                                                    Provider.of<Cart>(context,
                                                                listen: false)
                                                            .id ==
                                                        widget.bakery
                                                            .sellerId) if (Provider.of<
                                                                Cart>(context,
                                                            listen: false)
                                                        .quantity[countIndex] ==
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
                                              child: Text(
                                                countIndex == -1
                                                    ? "0"
                                                    : Provider.of<Cart>(context)
                                                        .quantity[countIndex]
                                                        .toString(),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Provider.of<Cart>(context,
                                                        listen: false)
                                                    .addPastry(
                                                        items[index],
                                                        widget.bakery.sellerId,
                                                        context,
                                                        new LatLng(
                                                            latitude: widget
                                                                .bakery
                                                                .latitude,
                                                            longitude: widget
                                                                .bakery
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

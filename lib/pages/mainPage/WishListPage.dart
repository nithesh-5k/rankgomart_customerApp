import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/model/Wishlist.dart';
import 'package:mart/pages/groceries/productPage.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatefulWidget {
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  var responseBody;
  List<WishList> wishlist = [];

  Future<void> getWishList() async {
    Map<String, String> body = {
      "custom_data": "customerwishlistdetails",
      "customerId": Provider.of<User>(context, listen: false).userId,
      "mainCategoryId": "1"
    };
    responseBody = await postRequestForList("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      if (responseBody['items']['itemList'] != "No Data Found") {
        setState(() {
          wishlist = wishListFromJson(responseBody['items']['itemList']);
        });
      } else {
        setState(() {
          wishlist.clear();
        });
      }
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getWishList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getWishList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Wish List", context: context),
      body: responseBody == null
          ? wishlist.length == 0
              ? Center(
                  child: Text("No items available"),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
          : wishlist.length == 0
              ? Center(
                  child: Text("No item available"),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    ProductPage(wishlist[index].productId)));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8)),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                    height: 130,
                                    child: Image.network(
                                        wishlist[index].imageUrl)),
                                Text(wishlist[index].productName),
                              ],
                            ),
                            Positioned(
                              top: -20,
                              right: -25,
                              child: IconButton(
                                onPressed: () {
                                  deleteItem(wishlist[index].productId);
                                },
                                padding: EdgeInsets.all(20),
                                icon: Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: wishlist.length,
                ),
    );
  }

  Future<void> deleteItem(String id) async {
    Map<String, String> body = {
      "custom_data": "customerwishlist",
      "customerId": Provider.of<User>(context, listen: false).userId,
      "mainCategoryId": "1",
      "productId": id,
      "operation": "remove"
    };
    responseBody = await postRequestForList("API/register_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      getWishList();
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getWishList();
      });
    }
  }
}

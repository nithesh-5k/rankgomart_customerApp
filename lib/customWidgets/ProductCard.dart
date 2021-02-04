import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mart/const.dart';
import 'package:mart/model/Item/GroceryItem.dart';
import 'package:mart/pages/groceries/productPage.dart';
import 'package:mart/provider/cart.dart';
import 'package:mart/provider/gps.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/dynamicLinkServices.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  GroceryItem product;

  ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    int save = double.parse(product.mrpPrice).round() -
        double.parse(product.salePrice).round();
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductPage.routeName,
            arguments: product.id);
      },
      child: Container(
        height: 310,
        width: MediaQuery.of(context).size.width / 2 - 10,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            Container(
                height: 130, child: Image.network(BASE_URL + product.imageUrl)),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(child: Text(product.name)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rs." + product.salePrice,
                          style: TextStyle(
                            color: kGreen,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Rs." + product.mrpPrice,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            save >= 5
                                ? Text(
                                    "Save Rs.$save",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kBlue,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                product.productAvailableStatus == "unavailable"
                    ? Center(
                        child: Text(
                          "Out of stock",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(
                        height: 40,
                        // width: 40,
                        decoration: BoxDecoration(
                            color: kGreen,
                            borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Provider.of<Cart>(context, listen: false)
                                  .addGrocery(
                                      product,
                                      context,
                                      null,
                                      Provider.of<GPS>(context, listen: false)
                                          .grocery);
                            }),
                      ),
                Container(
                  height: 40,
                  // width: 40,
                  decoration: BoxDecoration(
                      color: kBlue, borderRadius: BorderRadius.circular(5)),
                  child: IconButton(
                    icon: Icon(Icons.favorite_rounded, color: Colors.white),
                    onPressed: () {
                      addProductToWishList(
                          Provider.of<User>(context, listen: false).userId,
                          product,
                          context,
                          null);
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    DynamicLinkService.shareProduct(product);
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: kGreen,
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<void> addProductToWishList(String customerId, GroceryItem product,
    BuildContext context, GlobalKey<ScaffoldState> key) async {
  if (customerId == null) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 500),
      content: Text("Please login to add products to wishlist"),
    ));
    return;
  }
  Map<String, String> body = {
    "custom_data": "customerwishlist",
    "customerId": customerId,
    "mainCategoryId": "1",
    "productId": product.id,
    "operation": "add"
  };
  var responseBody2 = await postRequestForList("API/register_api.php", body);
  if (responseBody2['success'] == null ? false : responseBody2['success']) {
    if (key == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("${product.name} added to wishlist"),
      ));
    } else {
      key.currentState.showSnackBar(SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("${product.name} added to wishlist"),
      ));
    }
  }
}

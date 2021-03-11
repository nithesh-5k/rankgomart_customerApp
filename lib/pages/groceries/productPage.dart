import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/customWidgets/CustomFAB.dart';
import 'package:mart/customWidgets/ProductCard.dart';
import 'package:mart/model/Item/GroceryItem.dart';
import 'package:mart/provider/cart.dart';
import 'package:mart/provider/gps.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  static const routeName = '/productPage';

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  GroceryItem product;
  bool flag = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var responseBody;

  Future<void> getProduct(String id) async {
    Map<String, String> body = {
      "custom_data": "getsingleproduct",
      "productId": id
    };
    responseBody = await postRequest("API/homepage_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      setState(() {
        flag = false;
        product = GroceryItem.fromJson(responseBody['productDetails'][0]);
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getProduct(id);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    if (flag) {
      getProduct(id);
    }
    int save = double.parse(flag ? "0" : product.mrpPrice).round() -
        double.parse(flag ? "0" : product.salePrice).round();
    AppBar bar =
        CustomAppBar(title: flag ? " " : product.name, context: context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: bar,
      body: flag
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height -
                      74 -
                      bar.preferredSize.height,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  // width: MediaQuery.of(context).size.width,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                              child: Image.network(
                            BASE_URL + product.imageUrl,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              return preLoaderImage(
                                  child: child,
                                  loadingProgress: loadingProgress);
                            },
                          ))),
                      Text(
                        product.name,
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rs." + product.salePrice,
                            style: TextStyle(
                              fontSize: 20,
                              color: kGreen,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "Rs." + product.mrpPrice,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              save >= 5
                                  ? Text(
                                      "Save Rs.$save",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: kBlue,
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Product Description:",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        product.description ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: product.productAvailableStatus ==
                                    "unavailable"
                                ? Center(
                                    child: Text(
                                      "Out of stock",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Provider.of<Cart>(context, listen: false)
                                          .addGrocery(
                                              product,
                                              context,
                                              _scaffoldKey,
                                              Provider.of<GPS>(context,
                                                      listen: false)
                                                  .grocery);
                                    },
                                    child: Container(
                                      color: kBlue,
                                      child: Center(
                                        child: Text(
                                          "Add to cart",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                addProductToWishList(
                                    Provider.of<User>(context, listen: false)
                                        .userId,
                                    product,
                                    context,
                                    _scaffoldKey);
                              },
                              child: Container(
                                color: kGreen,
                                child: Center(
                                  child: Text(
                                    "Add to WishList",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: CustomFAB(),
      ),
    );
  }
}

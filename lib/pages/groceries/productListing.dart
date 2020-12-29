import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/customWidgets/CustomFAB.dart';
import 'package:mart/customWidgets/ProductCard.dart';
import 'package:mart/model/Category.dart';
import 'package:mart/model/Item/GroceryItem.dart';
import 'package:mart/services/request.dart';

class ProductListingPage extends StatefulWidget {
  Category category;

  ProductListingPage(this.category);

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  List<GroceryItem> products;
  var responseBody;

  Future<void> getProducts() async {
    Map<String, String> body = {
      "custom_data": "getcategoryproductlist",
      "categoryId": widget.category.categoryId
    };
    responseBody = await postRequestForList("API/homepage_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      setState(() {
        products = productsFromJson(responseBody['items']['product_details']);
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getProducts();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: widget.category.categoryName, context: context),
      body: responseBody == null
          ? Center(child: CircularProgressIndicator())
          : products.length == 0
              ? Center(
                  child: Text("No items are available"),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ProductCard(
                                products[(2 * index) % products.length]),
                            Container(
                              width: 1,
                              height: 320,
                              color: Colors.grey,
                            ),
                            products.length - 1 >= (2 * index) + 1
                                ? ProductCard(products[
                                    ((2 * index) + 1) % products.length])
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            10,
                                  ),
                          ],
                        ),
                        products.length - 1 >= (2 * index) + 1
                            ? Container(
                                height: 1,
                                color: Colors.grey,
                              )
                            : SizedBox(),
                      ],
                    );
                  },
                  itemCount: products.length % 2 == 0
                      ? (products.length / 2).floor()
                      : (products.length / 2).floor() + 1,
                ),
      floatingActionButton: CustomFAB(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomFAB.dart';
import 'package:mart/customWidgets/ProductCard.dart';
import 'package:mart/model/Category.dart';
import 'package:mart/model/Filter.dart';
import 'package:mart/model/Item/GroceryItem.dart';
import 'package:mart/pages/groceries/FilterPage.dart';
import 'package:mart/services/getData.dart';
import 'package:mart/services/request.dart';

class ProductListingPage extends StatefulWidget {
  Category category;

  ProductListingPage(this.category);

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  List<GroceryItem> products = [];
  var responseBody, responseBody1;
  ScrollController _controller;
  Filter _filter;

  Future<void> getProducts() async {
    Map<String, String> body = {
      "custom_data": "filterdata",
      "categoryId": widget.category.categoryId,
      "subcategoryId": _filter.subCategoryId,
      "brandId": _filter.brandId,
      "minimumPrice": _filter.changedMin.toString(),
      "maximumPrice": _filter.changedMax.toString(),
      "searchKeyword": "",
      "lastId": _filter.lastId,
      "queryLimit": Data.paginationLimit
    };
    responseBody = await postRequest("API/homepage_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      setState(() {
        _filter.totalCount = responseBody["totalcount"];
        _filter.lastId = responseBody["lastId"].toString();
        if (productsFromJson(responseBody["product_details"]) != null) {
          products.addAll(productsFromJson(responseBody["product_details"]));
        }
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getProducts();
      });
    }
  }

  Future<void> getFilterData() async {
    Map<String, String> body = {
      "custom_data": "getcategoryproductlist",
      "categoryId": widget.category.categoryId,
      "lastId": "0",
      "queryLimit": Data.paginationLimit
    };
    responseBody1 = await postRequest("API/homepage_api.php", body);
    if (responseBody1['success'] == null ? false : responseBody1['success']) {
      _filter.min = double.parse(responseBody1["minPrice"]);
      _filter.changedMin = double.parse(responseBody1["minPrice"]);
      _filter.max = double.parse(responseBody1["maxPrice"]);
      _filter.changedMax = double.parse(responseBody1["maxPrice"]);
      _filter.brand = brandsFromJson(responseBody1["brand_details"]);
      _filter.subCategory =
          subCategoriesFromJson(responseBody1["sub_category_details"]);
      setState(() {});
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getProducts();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filter = Filter();
    getFilterData();
    getProducts();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        products.length < _filter.totalCount) {
      getProducts();
    }
  }

  void filter() {
    products.clear();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        titleSpacing: 0,
        leading: null,
        title: Row(
          children: [
            Transform.translate(
              offset: Offset(-10, 0),
              child: IconButton(
                  icon: Icon(Icons.home_rounded),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }),
            ),
            Transform.translate(
              offset: Offset(-10, 0),
              child: Text(
                widget.category.categoryName,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_alt_rounded,
              color: kBlue,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => FilterPage(_filter, filter)));
            },
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: responseBody == null || responseBody1 == null
          ? Center(child: CircularProgressIndicator())
          : products.length == 0
              ? Center(
                  child: Text("No items are available"),
                )
              : ListView.builder(
                  controller: _controller,
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
                        Visibility(
                            visible: (products.length < _filter.totalCount) &&
                                (products.length % 2 == 0
                                    ? index == (products.length / 2).floor() - 1
                                    : index >
                                        (products.length / 2).floor() - 1),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircularProgressIndicator(),
                            ))
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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mart/customWidgets/CategoryCard.dart';
import 'package:mart/customWidgets/ProductCard.dart';
import 'package:mart/model/Banner.dart';
import 'package:mart/model/Category.dart';
import 'package:mart/model/Item/GroceryItem.dart';
import 'package:mart/pages/groceries/AllCategories.dart';
import 'package:mart/pages/groceries/SearchPage.dart';
import 'package:mart/pages/groceries/productPage.dart';
import 'package:mart/provider/gps.dart';
import 'package:mart/provider/user.dart';
import 'package:mart/services/getData.dart';
import 'package:mart/services/request.dart';
import 'package:provider/provider.dart';

import '../../const.dart';

class GroceriesMainPage extends StatefulWidget {
  @override
  _GroceriesMainPageState createState() => _GroceriesMainPageState();
}

class _GroceriesMainPageState extends State<GroceriesMainPage> {
  List<Category> categories = [];
  var responseBody, responseBody1, responseBody2, responseBody3;
  List<BannerImage> bannerImages = [];
  List<GroceryItem> category1Items = [];
  List<String> carouselData = [];

  Future<void> getCarouselData() async {
    Map<String, String> body = {"custom_data": "mainsliderlist"};
    responseBody3 = await postRequestForList("API/homepage_api.php", body);
    if (responseBody3['success'] == null ? false : responseBody3['success']) {
      setState(() {
        for (int i = 0;
            i < responseBody3['items']['sliderDetails'].length;
            i++) {
          carouselData.add(BASE_URL +
              responseBody3['items']['sliderDetails'][i]['sliderImagePath'] +
              responseBody3['items']['sliderDetails'][i]['sliderImage']);
        }
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getCarouselData();
      });
    }
  }

  Future<void> getCategories() async {
    Map<String, String> body = {"custom_data": "getcategorylist"};
    responseBody2 = await postRequestForList("API/homepage_api.php", body);
    if (responseBody2['success'] == null ? false : responseBody2['success']) {
      setState(() {
        categories =
            categoriesFromJson(responseBody2['items']['category_details']);
      });
      getProducts(categories[0].categoryId);
      Provider.of<GPS>(context, listen: false).setGrocery(
          longitude: double.parse(responseBody2['items']["longitude"]),
          latitude: double.parse(responseBody2['items']["latitude"]));
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getCategories();
      });
    }
  }

  Future<void> getProducts(String categoryId) async {
    Map<String, String> body = {
      "custom_data": "filterdata",
      "categoryId": categoryId,
      "subcategoryId": "",
      "brandId": "",
      "minimumPrice": "",
      "maximumPrice": "",
      "searchKeyword": "",
      "lastId": "0",
      "queryLimit": "20"
    };
    responseBody = await postRequestForList("API/homepage_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      setState(() {
        category1Items =
            productsFromJson(responseBody['items']['product_details']);
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getProducts(categoryId);
      });
    }
  }

  Future<void> getBanner() async {
    Map<String, String> body = {"custom_data": "homepagebannerlist"};
    responseBody1 = await postRequestForList("API/homepage_api.php", body);
    if (responseBody1['success'] == null ? false : responseBody1['success']) {
      setState(() {
        bannerImages = bannersFromJson(responseBody1['items']['bannerDetails']);
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getBanner();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initialCalls();
  }

  Future<void> initialCalls() async {
    if (BASE_URL == null) {
      await Data.getAPIData();
    }
    getCategories();
    getCarouselData();
    getBanner();
    Provider.of<User>(context, listen: false).fetchUserId();
  }

  @override
  Widget build(BuildContext context) {
    return (responseBody == null ||
            responseBody1 == null ||
            responseBody2 == null ||
            responseBody3 == null)
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(3)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Search",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 140,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items: carouselData
                        .map(
                          (item) => Container(
                            child: Center(
                              child: Image.network(
                                item,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  height: categories.length <= 12
                      ? (120 *
                          ((categories.length / 3).floorToDouble() +
                              (categories.length % 3 == 0 ? 0 : 1)))
                      : 540,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(5),
                    crossAxisCount: 3,
                    children: List.generate(
                        categories.length <= 12 ? categories.length : 12,
                        (index) {
                      return CategoryCard(
                        category: categories[index],
                      );
                    }),
                  ),
                ),
                Visibility(
                  visible: categories.length > 12,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => AllCategories(),
                          ));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "See all",
                            style: TextStyle(color: kBlue),
                          ),
                          Icon(Icons.arrow_forward, color: kBlue)
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ProductPage.routeName,
                        arguments: bannerImages[0].id);
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          Image.network(BASE_URL + bannerImages[0].imageUrl),
                          Positioned(
                            top: 40,
                            right: bannerImages[0].bannerContentAlign == "lhs"
                                ? null
                                : 10,
                            left: bannerImages[0].bannerContentAlign == "lhs"
                                ? 10
                                : null,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                children: [
                                  Text(
                                    bannerImages[0].title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    child: Text("Shop now"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    categories[0].categoryName,
                    style: kHeading,
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                for (int index = 0;
                    index < 3 && category1Items.length != 0;
                    index++)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProductCard(category1Items[
                              (2 * index) % category1Items.length]),
                          Container(
                            width: 1,
                            height: 320,
                            color: Colors.grey,
                          ),
                          ProductCard(category1Items[
                              ((2 * index) + 1) % category1Items.length]),
                        ],
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ProductPage.routeName,
                        arguments: bannerImages[1].id);
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          Image.network(BASE_URL + bannerImages[1].imageUrl),
                          Positioned(
                            top: 40,
                            right: bannerImages[1].bannerContentAlign == "lhs"
                                ? null
                                : 10,
                            left: bannerImages[1].bannerContentAlign == "lhs"
                                ? 10
                                : null,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                children: [
                                  Text(
                                    bannerImages[1].title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    child: Text("Shop now"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:mart/customWidgets/CategoryCard.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/model/Category.dart';
import 'package:mart/services/request.dart';

class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List<Category> categories = [];

  var responseBody2;

  Future<void> getCategories() async {
    Map<String, String> body = {"custom_data": "getcategorylist"};
    responseBody2 = await postRequestForList("API/homepage_api.php", body);
    if (responseBody2['success'] == null ? false : responseBody2['success']) {
      setState(() {
        categories =
            categoriesFromJson(responseBody2['items']['category_details']);
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        getCategories();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context, title: "All Categories"),
      body: responseBody2 == null
          ? Center(child: CircularProgressIndicator())
          : GridView.count(
              padding: EdgeInsets.all(5),
              crossAxisCount: 3,
              children: List.generate(categories.length, (index) {
                return CategoryCard(
                  category: categories[index],
                );
              }),
            ),
    );
  }
}

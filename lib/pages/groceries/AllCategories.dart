import 'package:flutter/material.dart';
import 'package:mart/customWidgets/CategoryCard.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/model/Category.dart';

class AllCategories extends StatelessWidget {
  List<Category> categories;

  AllCategories({this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context, title: "All Categories"),
      body: GridView.count(
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

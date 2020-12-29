class Category {
  Category({this.categoryId, this.categoryName, this.imageUrl});

  String categoryId;
  String categoryName;
  String imageUrl;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      imageUrl: json["categoryImagePath"] + json["categoryImage"],
    );
  }
}

List<Category> categoriesFromJson(responseBody) =>
    List<Category>.from(responseBody.map((x) => Category.fromJson(x)));

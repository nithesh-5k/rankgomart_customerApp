class Brand {
  Brand({this.id, this.name});

  String id;
  String name;

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json["brandId"], name: json["brandName"]);
  }
}

List<Brand> brandsFromJson(responseBody) =>
    List<Brand>.from(responseBody.map((x) => Brand.fromJson(x)));

class SubCategory {
  SubCategory({this.id, this.name});

  String id;
  String name;

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
        id: json["subCategoryId"], name: json["subCategoryName"]);
  }
}

List<SubCategory> subCategoriesFromJson(responseBody) =>
    List<SubCategory>.from(responseBody.map((x) => SubCategory.fromJson(x)));

class Filter {
  double min = 0, max = 1000000, changedMin = 0, changedMax = 1000000;
  int totalCount;
  String lastId = "0";
  String subCategoryId = "", brandId = "";
  List<int> brandCheck = [], subCategoryCheck = [];

  List<Brand> brand;
  List<SubCategory> subCategory;
}

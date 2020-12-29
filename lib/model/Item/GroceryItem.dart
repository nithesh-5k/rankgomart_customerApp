import 'package:mart/model/Item/IItem.dart';

class GroceryItem implements IItem {
  GroceryItem(
      {this.id,
      this.name,
      this.description,
      this.salePrice,
      this.imageUrl,
      this.mrpPrice,
      this.productAvailableStatus});

  String id;
  String name;
  String description;
  String salePrice;
  String imageUrl;
  String mrpPrice;
  String productAvailableStatus;

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
        id: json["productId"],
        name: json["productName"] +
            " - " +
            json["productPackSize"].toString() +
            " " +
            json["unitShortName"],
        imageUrl: json["imagePath"] + json["imageName"],
        description: json["productDescription"],
        salePrice: json["productSalePrice"],
        mrpPrice: json["productMrpPrice"],
        productAvailableStatus: json["productAvailableStatus"]);
  }
}

List<GroceryItem> productsFromJson(responseBody) =>
    List<GroceryItem>.from(responseBody.map((x) => GroceryItem.fromJson(x)));

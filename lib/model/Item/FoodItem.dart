import 'package:mart/model/Item/IItem.dart';

class FoodItem implements IItem {
  FoodItem(
      {this.id,
      this.name,
      this.imageUrl,
      this.salePrice,
      this.productAvailableStatus});

  String id;
  String name;
  String imageUrl;
  String salePrice;
  String mrpPrice = null;
  String productAvailableStatus;

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
        id: json["itemId"],
        name: json["itemName"],
        salePrice: json["itemSalePrice"],
        imageUrl: json["itemImagePath"] + json["itemImage"],
        productAvailableStatus: json["itemStockStatus"]);
  }
}

List<FoodItem> itemsFromJson(responseBody) =>
    List<FoodItem>.from(responseBody.map((x) => FoodItem.fromJson(x)));

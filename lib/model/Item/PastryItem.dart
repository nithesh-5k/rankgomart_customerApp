import 'package:mart/model/Item/IItem.dart';

class PastryItem implements IItem {
  PastryItem(
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

  factory PastryItem.fromJson(Map<String, dynamic> json) {
    return PastryItem(
        id: json["itemId"],
        name: json["itemName"],
        salePrice: json["itemSalePrice"],
        imageUrl: json["itemImagePath"] + json["itemImage"],
        productAvailableStatus: json["itemStockStatus"]);
  }
}

List<PastryItem> pastriesFromJson(responseBody) =>
    List<PastryItem>.from(responseBody.map((x) => PastryItem.fromJson(x)));

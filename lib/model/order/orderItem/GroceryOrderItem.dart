import 'package:mart/model/order/orderItem/OrderIItem.dart';

class GroceryOrderItem implements OrderIItem {
  @override
  String name;

  @override
  String price;

  @override
  String quantity;

  GroceryOrderItem({this.quantity, this.price, this.name});

  factory GroceryOrderItem.fromJson(Map<String, dynamic> json) {
    return GroceryOrderItem(
      name: json["productName"],
      price: json["orderProductSalePrice"],
      quantity: json["orderProductQuantity"],
    );
  }
}

List<GroceryOrderItem> groceryItemsFromJson(responseBody) =>
    List<GroceryOrderItem>.from(
        responseBody.map((x) => GroceryOrderItem.fromJson(x)));

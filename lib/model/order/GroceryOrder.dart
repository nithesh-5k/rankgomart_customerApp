import 'package:mart/model/order/IOrder.dart';
import 'package:mart/model/order/orderItem/GroceryOrderItem.dart';
import 'package:mart/model/order/orderItem/OrderIItem.dart';

class GroceryOrder implements IOrder {
  @override
  String orderCode;

  @override
  String orderCreatedDate;

  @override
  String orderCurrentStatus;

  @override
  String orderID;

  @override
  List<OrderIItem> items;

  GroceryOrder({
    this.orderCode,
    this.orderCreatedDate,
    this.orderCurrentStatus,
    this.orderID,
    this.items,
    this.mainCategoryId,
    this.totalOrderAmount,
  });

  factory GroceryOrder.fromJson(Map<String, dynamic> json) {
    return GroceryOrder(
      orderCode: json["orderCode"],
      orderCreatedDate: json["orderedCreatedDate"],
      orderCurrentStatus: json["orderCurrentStatus"],
      orderID: json["orderId"],
      mainCategoryId: json["mainCategoryId"].toString(),
      totalOrderAmount: json["totalOrderAmount"],
      items: groceryItemsFromJson(json["itemList"]),
    );
  }

  @override
  String mainCategoryId;

  @override
  String totalOrderAmount;

  @override
  String image;

  @override
  String locationName;
}

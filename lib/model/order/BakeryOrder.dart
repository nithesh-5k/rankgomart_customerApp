import 'package:mart/const.dart';
import 'package:mart/model/order/IOrder.dart';
import 'package:mart/model/order/orderItem/BakeryOrderItem.dart';
import 'package:mart/model/order/orderItem/OrderIItem.dart';

class BakeryOrder implements IOrder {
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

  BakeryOrder({
    this.orderCode,
    this.orderCreatedDate,
    this.orderCurrentStatus,
    this.orderID,
    this.items,
    this.mainCategoryId,
    this.totalOrderAmount,
    this.image,
    this.locationName,
  });

  factory BakeryOrder.fromJson(Map<String, dynamic> json) {
    return BakeryOrder(
      orderCode: json["bakeryOrderCode"],
      orderCreatedDate: json["orderedCreatedDate"],
      orderCurrentStatus: json["orderCurrentStatus"],
      orderID: json["bakeryOrderId"],
      mainCategoryId: json["mainCategoryId"].toString(),
      totalOrderAmount: json["totalOrderAmount"],
      items: bakeryItemsFromJson(json["itemList"]),
      image:
          BASE_URL + json["sellerBakeryImagePath"] + json["sellerBakeryImage"],
      locationName: json["sellerBakeryName"],
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

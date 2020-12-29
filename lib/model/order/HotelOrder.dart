import 'package:mart/const.dart';
import 'package:mart/model/order/IOrder.dart';
import 'package:mart/model/order/orderItem/HotelOrderItem.dart';
import 'package:mart/model/order/orderItem/OrderIItem.dart';

class HotelOrder implements IOrder {
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

  HotelOrder({
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

  factory HotelOrder.fromJson(Map<String, dynamic> json) {
    return HotelOrder(
      orderCode: json["hotelOrderCode"],
      orderCreatedDate: json["orderedCreatedDate"],
      orderCurrentStatus: json["orderCurrentStatus"],
      orderID: json["hotelOrderId"],
      mainCategoryId: json["mainCategoryId"].toString(),
      totalOrderAmount: json["totalOrderAmount"],
      items: hotelItemsFromJson(json["itemList"]),
      image: BASE_URL + json["sellerHotelImagePath"] + json["sellerHotelImage"],
      locationName: json["sellerHotelName"],
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

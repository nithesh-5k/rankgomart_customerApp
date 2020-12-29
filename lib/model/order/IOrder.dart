import 'package:mart/model/order/orderItem/OrderIItem.dart';

class IOrder {
  String orderID;
  String orderCode;
  String orderCreatedDate;
  String orderCurrentStatus;
  String mainCategoryId;
  String totalOrderAmount;
  String image;
  String locationName;
  List<OrderIItem> items;
}

import 'package:mart/const.dart';

class WishList {
  String productName;
  String imageUrl;
  String productId;

  WishList({this.productName, this.productId, this.imageUrl});

  factory WishList.fromJson(Map<String, dynamic> json) {
    return WishList(
        productId: json["productRefId"].toString(),
        productName: json["productName"] +
            " " +
            json["productPackSize"] +
            " " +
            json["unitShortName"],
        imageUrl: BASE_URL + json["imagePath"] + json["imageName"]);
  }
}

List<WishList> wishListFromJson(responseBody) =>
    List<WishList>.from(responseBody.map((x) => WishList.fromJson(x)));

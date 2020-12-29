import 'package:mart/const.dart';

class SearchItem {
  SearchItem({
    this.id,
    this.name,
    this.imageUrl,
  });

  String id;
  String name;
  String imageUrl;

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      id: json["productId"],
      name: json["productName"] +
          " " +
          json["productPackSize"] +
          " " +
          json["unitShortName"],
      imageUrl: BASE_URL + json["imagePath"] + json["imageName"],
    );
  }
}

List<SearchItem> searchFromJson(responseBody) =>
    List<SearchItem>.from(responseBody.map((x) => SearchItem.fromJson(x)));

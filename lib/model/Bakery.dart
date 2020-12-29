class Bakery {
  Bakery(
      {this.sellerId,
      this.sellerBakeryName,
      this.sellerBakeryImage,
      this.longitude,
      this.latitude});

  String sellerId;
  String sellerBakeryName;
  String sellerBakeryImage;
  double longitude;
  double latitude;

  factory Bakery.fromJson(Map<String, dynamic> json) {
    return Bakery(
        sellerId: json["sellerId"],
        sellerBakeryName: json["sellerBakeryName"],
        sellerBakeryImage:
            json["sellerBakeryImagePath"] + json["sellerBakeryImage"],
        longitude: double.parse(json["sellerBakeryLongitude"]),
        latitude: double.parse(json["sellerBakeryLatitude"]));
  }
}

List<Bakery> bakeriesFromJson(responseBody) =>
    List<Bakery>.from(responseBody.map((x) => Bakery.fromJson(x)));

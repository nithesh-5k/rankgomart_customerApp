class Hotel {
  Hotel(
      {this.sellerId,
      this.sellerHotelName,
      this.sellerHotelImage,
      this.longitude,
      this.latitude});

  String sellerId;
  String sellerHotelName;
  String sellerHotelImage;
  double longitude;
  double latitude;

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
        sellerId: json["sellerId"],
        sellerHotelName: json["sellerHotelName"],
        sellerHotelImage:
            json["sellerHotelImagePath"] + json["sellerHotelImage"],
        longitude: double.parse(json["sellerHotelLongitude"]),
        latitude: double.parse(json["sellerHotelLatitude"]));
  }
}

List<Hotel> categoriesFromJson(responseBody) =>
    List<Hotel>.from(responseBody.map((x) => Hotel.fromJson(x)));

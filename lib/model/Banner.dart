class BannerImage {
  BannerImage({this.id, this.title, this.imageUrl, this.bannerContentAlign});

  String id;
  String title;
  String imageUrl;
  String bannerContentAlign;

  factory BannerImage.fromJson(Map<String, dynamic> json) {
    return BannerImage(
        id: json["homePageproductRefId"],
        title: json["bannerName"],
        imageUrl: json["bannerImagePath"] + json["bannerImage"],
        bannerContentAlign: json["bannerContentAlign"]);
  }
}

List<BannerImage> bannersFromJson(responseBody) =>
    List<BannerImage>.from(responseBody.map((x) => BannerImage.fromJson(x)));

class UserModel {
  UserModel({
    this.customerName,
    this.customerMobileNumber,
    this.customerEmailId,
    // this.addresses
  });

  String customerName;
  String customerMobileNumber;
  String customerEmailId;
  // List<Address> addresses;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      customerName: json["customerName"],
      customerMobileNumber: json["customerMobileNumber"],
      customerEmailId: json["customerEmailId"] ?? "",
      // addresses: addressesFromJson(json["customerAddress"]
    );
  }
}

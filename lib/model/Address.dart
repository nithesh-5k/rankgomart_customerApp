class Address {
  Address(
      {this.customerAddressId,
      this.customerAddress,
      this.customerCountryId,
      this.customerStateId,
      this.customerCityId,
      this.customerPincode});

  String customerAddressId;
  String customerAddress;
  String customerCountryId;
  String customerStateId;
  String customerCityId;
  String customerPincode;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      customerAddressId: json["customerAddressId"],
      customerAddress: json["customerAddress"],
      customerCountryId: json["customerCountryId"],
      customerStateId: json["customerStateId"],
      customerCityId: json["customerCityId"],
      customerPincode: json["customerPincode"],
    );
  }
}

List<Address> addressesFromJson(responseBody) =>
    List<Address>.from(responseBody.map((x) => Address.fromJson(x)));

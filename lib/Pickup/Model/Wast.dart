class PickupBag {
  PickupBag({
    this.id,
    this.bagCode,
    this.wasteType,
  });

  int id;

  String bagCode;
  String wasteType;

  factory PickupBag.fromJson(Map<String, dynamic> json) => PickupBag(
        id: json["id"] ?? '',
        bagCode: json["bag_code"] ?? '',
        wasteType: json["waste_type"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id ?? '',
        "bag_code": bagCode ?? '',
        "waste_type": wasteType ?? '',
      };
}

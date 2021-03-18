import 'dart:convert';

class CouponModel {
  int id;
  String name;
  int value;
  int minShopping;
  int maxQuantity;
  int used;
  int state;

  CouponModel(
    this.id,
    this.name,
    this.value,
    this.minShopping,
    this.maxQuantity,
    this.used,
    this.state,
  );

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        json["id"],
        json["name"],
        json["value"],
        json["min_shopping"],
        json["max_quantity"],
        json["used"],
        json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "min_shopping": minShopping,
        "max_quantity": maxQuantity,
        "used": used,
        "state": state,
      };
}

import 'dart:convert';
import 'dart:io';

import 'package:engage/models/productModel.dart';

class CartItemModel {
  int id;
  int productId;
  int price;
  int quantity;
  int cartId;
  String name;
  List<ProductModel> cartProducts;

  CartItemModel(this.id, this.productId, this.price, this.quantity, this.cartId,
      this.name,
      {this.cartProducts});

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        json["id"],
        json["product_id"],
        json["precio"],
        json["cantidad"],
        json["cart_id"],
        json["name"],
        cartProducts:
            json["get_product"] != null && json["get_product"].length > 0
                ? List<ProductModel>.from(
                    json["get_product"].map((x) => ProductModel.fromJson(x)))
                : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "precio": price,
        "cantidad": quantity,
        "cart_id": cartId,
        "name": name,
        "get_product": List<dynamic>.from(cartProducts.map((x) => x.toJson())),
      };
}

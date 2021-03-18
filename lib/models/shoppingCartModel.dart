import 'dart:convert';
import 'dart:io';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/cartItemModel.dart';

import 'package:engage/app/engageApp.dart' as app;

class ShoppingCartModel {
  int id;
  int userId;
  List<CartItemModel> cartItems;

  ShoppingCartModel(
    this.id,
    this.userId,
    this.cartItems,
  );

  factory ShoppingCartModel.fromJson(Map<String, dynamic> json) {
    return ShoppingCartModel(
      json['id'],
      json['user_id'],
      List<CartItemModel>.from(
          json['get_details'].map((x) => CartItemModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'get_details': List<dynamic>.from(cartItems.map((x) => x.toJson())),
      };
}

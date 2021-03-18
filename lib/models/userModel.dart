import 'dart:convert';
import 'dart:io';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/commerceModel.dart';
import 'package:engage/models/shoppingCartModel.dart';

class UserModel {
  int userID;

  String userDocument;
  String phoneNumber;
  String password;

  String firstName;
  String lastName;
  String email;
  bool isPremium;
  bool isVerified;

  ShoppingCartModel userShoppingCart;	

  List<CommerceModel> userCommerceList = [];

  UserModel(this.userDocument, this.phoneNumber, this.password, this.firstName,
      this.lastName, this.email,
      {this.userID, this.userCommerceList, this.isPremium, this.isVerified});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        json["document"],
        json["cellphone"],
        json["password"],
        json["name"],
        json["last_name"],
        json["email"],
        userID: json['id'],
        userCommerceList:
            json["get_commerce"] != null && json["get_commerce"].length > 0
                ? List<CommerceModel>.from(
                    json["get_commerce"].map((x) => CommerceModel.fromJson(x)))
                : [],
      );

  Map<String, dynamic> toJson() => {
        "id": this.userID,
        "document": this.userDocument,
        "cellphone": this.phoneNumber,
        "password": this.password,
        "name": this.firstName,
        "last_name": this.lastName,
        "email": this.email,
        "get_commerce": this.userCommerceList.length > 0
            ? List<dynamic>.from(userCommerceList.map((x) => x.toJson()))
            : [],
      };

  ShoppingCartModel get shoppingCart => this.userShoppingCart;

  List<CommerceModel> get commerceList => this.userCommerceList;
}

import 'dart:convert';
import 'dart:io';

class ProductModel {
  int productID;
  int categoryID;
  int commerceID;

  String name;
  String description;

  List<dynamic> imageLocation;

  String imageURL;
  File imageFile;

  int discount = 0;
  int stock;
  int price;

  ProductModel(
      this.name, this.categoryID, this.price, this.stock, this.commerceID,
      {this.productID, this.discount, this.imageLocation, this.imageURL});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        json['name'],
        json['category_id'],
        json['price'],
        json['stock'],
        json['id_commerce'],
        productID: json['id'],
        discount: json['discount'],
        imageURL: json['img_product'],
      );

  Map<String, dynamic> toJson() => {
        "id": this.productID != null ? this.productID : null,
        "name": this.name,
        'category_id': this.categoryID,
        "price": this.price,
        "stock": this.stock,
        'id_commerce': this.commerceID,
        'discount': this.discount,
      };
}

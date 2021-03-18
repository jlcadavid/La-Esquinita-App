import 'dart:convert';
import 'dart:io';

enum Premium { none, premium }

class CommerceModel {
  int ownerID;
  int commerceID;

  String commerceName;
  String commerceAddress;

  bool active = false;

  double rating = 0.0;

  int premium = 0;

  CommerceModel(this.ownerID, this.commerceName, this.commerceAddress,
      {this.commerceID, this.active, this.rating, this.premium});

  factory CommerceModel.fromJson(Map<String, dynamic> json) => CommerceModel(
        json["user_id"],
        json["bussiness_name"],
        json["address"] == null ? json["commerce_address"] : json["address"],
        commerceID: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": this.commerceID,
        "user_id": this.ownerID,
        "bussiness_name": this.commerceName,
        "commerce_address": this.commerceAddress,
      };

  String get title => this.commerceName;

  String get address => this.commerceAddress;

  int get commerceOwnerID => this.ownerID;

  double get commerceRating => this.rating;

  int get isPremium => this.premium;

  String get description =>
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam iaculis magna turpis, sagittis fringilla tellus interdum at. Fusce at molestie metus, id suscipit neque. Proin cursus vitae neque non malesuada. Sed euismod ullamcorper nisi tempor tempus. Sed at est vitae elit porttitor dignissim lacinia vitae massa. Nam suscipit est sed nunc tincidunt ullamcorper. Ut enim sem, laoreet eget elementum ut, sodales sed erat. Curabitur at nunc sit amet nibh sagittis facilisis sit amet vel elit. Vestibulum at elit tincidunt, sagittis nibh vel, ultricies ligula.";
}

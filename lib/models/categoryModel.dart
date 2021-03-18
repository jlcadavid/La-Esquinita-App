import 'dart:convert';
import 'dart:io';

List<CategoryModel> categoriesFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoriesToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  int id;
  String name;
  String imgCategory;
  int outstanding;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  int state;

  CategoryModel({
    this.id,
    this.name,
    this.imgCategory,
    this.outstanding,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.state,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        imgCategory: json["img_category"],
        outstanding: json["outstanding"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "img_category": imgCategory,
        "outstanding": outstanding,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "state": state,
      };
}

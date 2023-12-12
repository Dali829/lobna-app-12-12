import 'dart:convert';

List<CategoryModel> CategoryModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromMap(x)));

class CategoryModel {
  String id;
  String categoryName;
  String categoryDescription;
  String? categoryPhoto;
  CategoryModel(
      {required this.id,
      required this.categoryName,
      required this.categoryDescription,
      required this.categoryPhoto});
  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['_id'],
        categoryName: json['categoryName'],
        categoryDescription: json['categoryDescription'],
        categoryPhoto: json['categoryPhoto']);
  }
}

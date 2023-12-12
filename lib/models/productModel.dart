import 'dart:convert';

List<ProductModel> ProductModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromMap(x)));

class ProductModel {
  String id;
  String productName;
  String productDescription;
  int unitPrice;
  String? productImage;
  String categoryId;
  ProductModel(
      {required this.id,
      required this.productName,
      required this.productDescription,
      required this.unitPrice,
      required this.productImage,
      required this.categoryId});
  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
        id: json['_id'],
        productName: json['productName'],
        productDescription: json['productDescription'],
        productImage: json['productImage'],
        unitPrice: json['unitPrice'],
        categoryId: json['categoryId']);
  }
}

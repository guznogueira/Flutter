import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  String cartID;
  String category;
  String productID;
  int quantity;
  String size;
  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    cartID = document.id;
    category = document.get("category");
    productID = document.get("productID");
    quantity = document.get("quantity");
    size = document.get("size");
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "productID": productID,
      "quantity": quantity,
      "size": size,
      "product": productData.toResumeMap(),
    };
  }
}

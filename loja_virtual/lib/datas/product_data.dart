import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String id;
  String title;
  String description;
  String category;
  double price;
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot doc) {
    this.id = doc.id;
    this.title = doc.get("title");
    this.description = doc.get("description");
    this.price = doc.get("price") + 0.0;
    this.images = doc.get("images");
    this.sizes = doc.get("sizes");
  }
}

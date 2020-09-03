import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/titles/category_title.dart';

class CategoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("products").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var dividerTitles = ListTile.divideTiles(
                  tiles: snapshot.data.docs.map((doc) {
                    return CategoryTitle(doc);
                  }).toList(),
                  color: Theme.of(context).primaryColor)
              .toList();
          return ListView(
            children: dividerTitles,
          );
        }
      },
    );
  }
}

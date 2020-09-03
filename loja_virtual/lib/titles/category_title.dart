import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryTitle extends StatelessWidget {
  final DocumentSnapshot doc;

  CategoryTitle(this.doc);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 26.0,
        child: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(doc.get("icon")),
        ),
      ),
      title: Text(doc.get("title")),
      trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).primaryColor,),
      onTap: () {

      },
    );
  }
}

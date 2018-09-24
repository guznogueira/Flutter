import 'package:flutter/material.dart';
import 'package:share/share.dart'; //biblioteca para compartilhar cousas

class GifPage extends StatelessWidget {

  //Dados do gif que sera mostrado
  final Map _gifData;

  //construtor
  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_gifData["title"]),
          backgroundColor: Colors.black,
          actions: <Widget>[
            //este sera o botão para compartilhar cousas
            IconButton(
              icon: Icon(Icons.share),
              onPressed: (){
                Share.share(_gifData["images"]["fixed_height"]["url"]);
              },
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Image.network(_gifData["images"]["fixed_height"]["url"]),
        ),
      ),
    );
  }
}
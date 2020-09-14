import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';

class ProductScreen extends StatefulWidget {
  final ProductData productData;

  ProductScreen(this.productData);

  @override
  _ProductScreenState createState() => _ProductScreenState(productData);
}

class _ProductScreenState extends State<ProductScreen> {
  String sizeSelected;

  final ProductData productData;

  _ProductScreenState(this.productData);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(productData.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: productData.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 8.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: Colors.grey,
              autoplay: false,
              dotIncreasedColor: primaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  productData.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${productData.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: productData.sizes.map((size) {
                      return GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(
                              color: size == sizeSelected
                                  ? primaryColor
                                  : Colors.grey[500],
                              width: 2.0,
                            ),
                          ),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text(size),
                        ),
                        onTap: () {
                          setState(() {
                            sizeSelected = size;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: sizeSelected != null ? (){} : null,
                    child: Text(
                      "Adicionar ao Carrinho",
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  productData.description,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

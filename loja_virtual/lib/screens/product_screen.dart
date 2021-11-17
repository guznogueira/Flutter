import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

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
  final _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      key: _scaffoldState,
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
              dotSize: 5.0,
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
                  child: ScopedModelDescendant<CartModel>(
                    builder: (context, child, model) {
                      return RaisedButton(
                        onPressed: () {
                          if (UserModel.of(context).isLoggedIn()) {
                            if (sizeSelected != null) {
                              bool hasProduct = false;
                              model.products.forEach((prod) {
                                if (prod.productID == productData.id) {
                                  hasProduct = true;
                                }
                              });

                              if (!hasProduct) {
                                CartProduct cartProduct = CartProduct();

                                cartProduct.size = sizeSelected;
                                cartProduct.quantity = 1;
                                cartProduct.productID = productData.id;
                                cartProduct.category = productData.category;
                                cartProduct.productData = productData;

                                CartModel.of(context).addCartItem(cartProduct);
                              }

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Selecione o tamanho"),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ));
                            }
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          }
                        },
                        child: Text(
                          UserModel.of(context).isLoggedIn()
                              ? "Adicionar ao Carrinho"
                              : "Faça o login para comprar",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        color: primaryColor,
                      );
                    },
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

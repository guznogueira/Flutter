//https://api.giphy.com/v1/gifs/trending?api_key=e7lN5bRaW7mKvScOytsP6f6rnapFy6kH&limit=20&rating=G
//https://api.giphy.com/v1/gifs/search?api_key=e7lN5bRaW7mKvScOytsP6f6rnapFy6kH&q=dogs&limit=25&offset=75&rating=G&lang=pt

import 'package:flutter/material.dart';

/*Este app irá trabalhar com mais de uma tela, e para não poluir o código, criamos um arquivo chamado home_page
onde este sera nossa outra interface, e importamos ela aki */
import 'package:buscador_de_gifs/ui/home_page.dart';
import 'package:buscador_de_gifs/ui/gif_page.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.white),
  ));
}


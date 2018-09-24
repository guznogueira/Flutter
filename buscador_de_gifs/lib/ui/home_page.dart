import 'dart:async';
import 'dart:convert';
import 'package:share/share.dart'; //biblioteca para compartilhar cousas

import 'package:buscador_de_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:transparent_image/transparent_image.dart'; //imagem transparente

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search == "") {
      response = await http.get(
          //Aki o limit=4 por causa do tablet que estou usando
          "https://api.giphy.com/v1/gifs/trending?api_key=e7lN5bRaW7mKvScOytsP6f6rnapFy6kH&limit=4&rating=G");
    } else {
      //olha o nosso _search pra pesquisa no meio da URL ai Gente!!!!
      //colocado manualmente não eh automatico nem magia
      //O mesmo pro _offset
      response = await http.get(
          //Aki o limit=3 por causa do tablet que estou usando
          "https://api.giphy.com/v1/gifs/search?api_key=e7lN5bRaW7mKvScOytsP6f6rnapFy6kH&q=$_search&limit=3&offset=$_offset&rating=G&lang=pt");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"), //uma gif na app bar
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          //colocando dentro do Padding, voce pode dar aquele espaço nas laterais
          Padding(
            //espaço de 30 em todos os lados do componente
            padding: EdgeInsets.all(30.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui!",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
              //chama função quando algo eh digitado, e clicado no botão
              //confirmar do teclado
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      //para mostrar que esta carregando
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        //a grossura da linha da bolinha que fica rodando
                        strokeWidth: 3.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(
                          context, snapshot); //caso haja gifs
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

//aki sera onde ira mostrar ou não mais gifs
  int _getCount(List data) {
    //caso não esteja pesquisando, mostrara todos os 20 na tela
    if (_search == null || _search == "") {
      //era pra ser return "data.length"
      //mas tablet não aguenta entao...
      return data.length;
    }
    //caso esteja pesquisando, ira mostrar 1 a mais, assim fica um espaço
    //vazio, pra colocar o botão pra carregar mais gifs
    else {
      return data.length + 1;
    }
  }

//aki sera onde mostraremos os gifs na tela
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //numero de itens que podera ter na horizontal
        crossAxisCount: 2,
        //espaçamento dos itens na horizontal, margem direita do item 1 e esquerda do item 2
        crossAxisSpacing: 10.0,
        //espaçamento dos itens na vertical, margem de baixo do item 1 e de cima do item 2
        mainAxisSpacing: 10.0,
      ),
      //numero de gifs na tela
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        //se não estiver pesquisando ou se não for o ultimo item, mostra o gif
        //ou seja, aki eh onde vera se deve ou não colocar o botao
        //pra carregar mais itens
        if (_search == null ||
            _search == "" ||
            index < snapshot.data["data"].length) {
          return GestureDetector(
            /*O que ta sendo feito no FadeInImage, eh ao invez do gif aparecer na 
            tela de uma vez, agora ele esta surgindo lentamente, graças ao kTransparentImage*/
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height_small"]
                  ["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),

            //se der aqueles dois toques ele abre uma nova tela
            onDoubleTap: () {
              //Aki eh onde ira fazer a tranzação de uma tela para a outra
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },

            //se apertar e segurar ele abre a opção de compartilhar
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 3;
                });
              },
            ),
          );
        }
      },
    );
  }
}

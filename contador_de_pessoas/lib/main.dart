import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Contador de Pessoas",
    home: Home()));
}


class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _people = 0;
  String _infoText = "Pode Entrar!";

  void _changePeople(int delta){
    //o setState é pra atualizar apenas o que foi modificado na tela, toda vez que alterar o valor de _people
    setState(() {
      int _aux = 0;
      _aux += _people + delta;

      if(_aux <= 0){
        _infoText = "Vazio!";
        _aux = _people = 0;
      }
      else if(_aux <= 10){
        _infoText = "Seja Bem Vindo!";
        _people = _aux;
      }
      else if(_aux > 10){
        _infoText = "Desculpa Estamos Lotado!!";
        _aux = _people = 11;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack( //o Stack é pra colocar um widget sobrepondo outro, primeiro o widget que vai em baixo depois em cima
    //o widget que vai em baixo sera a imagem.
      children: <Widget>[

        //esta é a imagem
        Image.asset(
          "imagem/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000.0, //era pra funfar sem mas ok
        ),
        //agora o restante, que vira por cima da imagem
        Column(
      //Para Centralizar tudo que estiver dentro desta coluna
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Texto 1
        Text(
          "Pessoas: $_people",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        
        Row(
          //Para Centraliza tudo que estiver dentro da linha
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Para fazer o espaçamento entre os botões
            Padding(
              padding: EdgeInsets.all(10.0),
              child: //Botão 1
                  FlatButton(
                child: Text(
                  "+1",
                  style: TextStyle(fontSize: 40.0, color: Colors.white),
                ),
                onPressed: () {
                  _changePeople(1);
                  },
              ),
            ),

            //Para fazer o espaçamento entre os botões
            Padding(
              padding: EdgeInsets.all(10.0),
              child: //Botão 2
                  FlatButton(
                child: Text(
                  "-1",
                  style: TextStyle(fontSize: 40.0, color: Colors.white),
                ),
                onPressed: () {
                  _changePeople(-1);
                  },
              ),
            ),
          ],
        ),

        //Texto 2
        Text(
          _infoText,
          style: TextStyle(
              color: Colors.white, fontStyle: FontStyle.italic, fontSize: 30.0),
        )
      ],
    ),
      ],
    );
  }
}
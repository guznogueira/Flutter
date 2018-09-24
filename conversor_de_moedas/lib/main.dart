import 'package:flutter/material.dart';
import 'dart:convert'; //transformar em json
import 'package:http/http.dart' as http;
import 'dart:async';
/*eh o responsavel por não ter de ficar
                      travado esperando resposta do servidor*/

const request = "https://api.hgbrasil.com/finance?format=json&key=68044806";

//async eh pro app nao ficar travado enquanto espera pelo servidor
void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController(); 
  final dolarController = TextEditingController(); 
  final euroController = TextEditingController(); 

  double dolar;
  double euro;

  /*função para quando os campos forem alterados*/
  void _realChanged(String text){
      double real = double.parse(text);
      dolarController.text = (real/dolar).toStringAsFixed(2);
      euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dolar1 = double.parse(text);
    realController.text = (dolar1 * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar1 * this.dolar)/euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro1 = double.parse(text);
    realController.text = (euro1 * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro1 * this.euro) / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "\$ Conversor \$",
          style: TextStyle(fontSize: 40.0),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      //FutureBuilder ira mostrar um carregando enquanto aguarda os dardos
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //para ver o status da conexão
            case ConnectionState.none:
            case ConnectionState.waiting:
              /*O Center() ele ira centralizar outro widget, ou seja, ira centralizar 
              o Carregando na tela*/
              return Center(
                child: Text(
                  "Carregando...",
                  style: TextStyle(color: Colors.amber, fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
              );

            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 30.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                /*agora a variavel dolar, ira receber o valor de compra, que eh o buy
                que esta dentro de USD, que esta dentro de currencies, que esta dentro de results*/
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];

                /*O mesmo pro Euro*/
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                /*O SingleChildScrollView eh pra fazer aquele rolamento na tela*/
                return SingleChildScrollView(
                  padding: EdgeInsets.all(50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 200.0,
                        color: Colors.amber,
                      ),

                      /*Este buildTextField, eh nosso TextField, porem desta forma
                      economizamos linaha de codigo*/

                      buildTextField("Reais", "R\$", realController, _realChanged),

                      Divider(), // só pr dar um espaço

                      buildTextField("Dolares", "US\$", dolarController, _dolarChanged),

                      Divider(), // só pr dar um espaço

                      buildTextField("Euros", "€", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

//essa funcao ira criar nosso text field, assim não ha necessidade de
//repetir o mesmo codigo 3x
Widget buildTextField(String label, String prefix, TextEditingController controller, Function funcao) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 20.0),
    onChanged: funcao,
  );
}

/*esta função ira retornar um map, porem apenas no futuro, pois devera
esperar pela resposta do servidor de onde virão estes dados*/
Future<Map> getData() async {
  //para que o app não fique parado enquanto espera resposta do servidor
  http.Response response = await http.get(request);

  /*o json.decode, pega a String vinda do site, e transforma ela em um map
  agora devemos percorrer o map, afim de obter os dados.
  Se pensarmos que esta tudo em camadas, primeiro entramos na camada results,
  ou seja, pegamos tudo que esta dentro de results, em seguida currencies
  e USD, eh onde estarão os dados a respeito do Dolar*/
  return json.decode(response.body);
}

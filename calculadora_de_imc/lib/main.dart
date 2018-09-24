import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 

  String _infoText = "Informe os Dados!";

  //minha função para reload da tela, o "_" antes do nome, eh apenas
  //para indicar que eh privada
  void _resetFields() {
    
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe os Dados!";
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = 0.0;

      imc = weight / (height * height);

      if (imc < 18.6) {
        _infoText =
            "Esta Abaixo do Peso!, IMC...:(${imc.toStringAsPrecision(3)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText =
            "Esta no Peso Ideal!, IMC...:(${imc.toStringAsPrecision(3)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText =
            "Esta Levemente Acima do Peso!, IMC...:(${imc.toStringAsPrecision(3)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "Obesidade Grau I!, IMC...:(${imc.toStringAsPrecision(3)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText =
            "Obesidade Grau II!, IMC...:(${imc.toStringAsPrecision(3)})";
      } else if (imc >= 40) {
        _infoText =
            "Obesidade Grau III!, IMC...:(${imc.toStringAsPrecision(3)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //o Scaffold facilida a vida, pois ajuda com as appBar
    return Scaffold(
      appBar: AppBar(
        //minha barra que aparecera no topo da aplicação
        title: Text(
          "Calculadora de IMC", //titulo que estara na barra
          style: TextStyle(fontSize: 30.0),
        ),
        centerTitle: true, //crentralizar o titulo que esta na barra
        backgroundColor: Colors.green, //cor de fundo da barra
        actions: <Widget>[
          IconButton(
            icon: Icon(
                Icons.refresh), //botão de refresh padrão, na barra superiora
            onPressed: _resetFields,
          )
        ],
      ),

      //fora da barra agora
      backgroundColor: Colors.white, //cor de fundo da aplicação
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            50.0, 10.0, 50.0, 10.0), //para definir aquela margem, a borda
        child: Form( //Este form, eh para mais a frente validar os campos, ver se estão preenchidos
          key: _formKey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          /*centraliza no topo
                                                        por ser coluna, o alinhamento eh vertical, 
                                                        então deve se usar o crossAxisAlignment, para manipular 
                                                        o eixo cruzado, ou seja, o eixo na horizontal*/
          children: <Widget>[
            Icon(
              Icons.person_outline, //icone de pessoa, padrão
              size: 300.0, color: Colors.green,
            ),

            //campo peso
            TextFormField( //O TextFormField, possui um parametro que ajuda na validação de dados.
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Peso (Kg)",
                  labelStyle: TextStyle(color: Colors.green)),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: 30.0),
              controller: weightController,
              validator: (value){
                if(value.isEmpty){
                  return "Insira um Peso!";
                }
              }
            ),

            //campo altura
            TextFormField( //O TextFormField, possui um parametro que ajuda na validação de dados.
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Altura (cm)",
                  labelStyle: TextStyle(color: Colors.green)),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: 30.0),
              controller: heightController,
              validator: (value){
                if(value.isEmpty){
                  return "Insira uma Altura!";
                }
              }
            ),

            //Padding para poder fazer uma margem
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0,
                  bottom:
                      20.0), //define a margem do topo e de baixo do componente
              child: Container(
                //Cria-se um Container, para definir o tamanho do botão neste caso
                height: 70.0,
                child: RaisedButton(
                  //Botão é RaisedButton pois, possui um fundo
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      _calculate();
                    }
                  },
                  child: Text(
                    "Calcular",
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                  color: Colors.green, //Cor do botão
                ),
              ),
            ),

            //Text de saida
            Text(
              _infoText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: 30.0),
            ),
          ],
        ),
        )
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];

  final _toDoController = TextEditingController();

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);

      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1)); //apenas enrolando pra dar inpressão de estar ordenando e tals

    setState(() {
      _toDoList.sort((a, b) {
        //ordenando a lista
        if (a["ok"] && !b["ok"]) {
          return 1;
        } else if (!a["ok"] && b["ok"]) {
          return -1;
        } else {
          return 0;
        }
      });

      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de Tarefas!",
          style: TextStyle(fontSize: 30.0),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 2.0, 10.0, 2.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                    controller: _toDoController,
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: buildItem),
            ),
          ),
        ],
      ),
    );
  }

//Responsavel por cada item da lista
  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now()
          .millisecondsSinceEpoch
          .toString()), //informa qual esta apagando, deslizando, no caso esta pegando o tempo em milisegundos para identificar
      //O Dismissible eh quem ira permitir deslizar para direita para apagar item da lista
      background: Container(
        color: Colors.red,
        child: Align(
          //O Align eh quem fara com que o icone a seguir fique escondido ao inves de ficar centralizado na tela
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd, //direção do deslizar para apagar
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(
            _toDoList[index]["ok"] ? Icons.check : Icons.error,
          ),
        ),
        onChanged: (check) {
          setState(() {
            _toDoList[index]["ok"] = check;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]} \" removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _toDoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 4),
          );
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  /*Future pois o local onde sera salvo, eh algo que devera ser buscado ainda
então pode levar um tempo*/
  Future<File> _getFile() async {
    final directory =
        await getApplicationDocumentsDirectory(); // vai pegar o diretorio onde poderar armazernar os dados do app
    return File(
        "${directory.path}/data.json"); //este eh o diretorio onde sera salvo
  }

/*Funcao para salvar os dados*/
  Future<File> _saveData() async {
    String data = json.encode(
        _toDoList); // pega a lista, tranforma em json e passa pra string
    final file = await _getFile();
    /*arquivo onde sera salvo, await porque devera espera para que chega a resposta,
                                    ja que a função retorna um ponto futuro*/

    return file.writeAsString(data);
  }

  //funcao para recuperar os dados salvos
  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}

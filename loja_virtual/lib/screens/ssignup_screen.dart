import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: "Nome Completo"),
                keyboardType: TextInputType.name,
                validator: (text) {
                  if (text.isEmpty) return "Nome inválido!";
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if (text.isEmpty || !text.contains("@"))
                    return "Email inválido!";
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Senha"),
                obscureText: true,
                validator: (text) {
                  if (text.isEmpty || text.length < 6) return "Senha inválida!";
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Endereço"),
                keyboardType: TextInputType.streetAddress,
                validator: (text) {
                  if (text.isEmpty) return "Endereço inválido!";
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: 50.0,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {}
                  },
                  child: Text(
                    "Cadastrar-se",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          )),
    );
  }
}

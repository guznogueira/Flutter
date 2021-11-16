import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: [
                      TextFormField(
                        decoration: InputDecoration(hintText: "Nome Completo"),
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (text) {
                          return text.isEmpty ? "Nome inválido!" : null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Email"),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          return (text.isEmpty || !text.contains("@"))
                              ? "Email inválido!"
                              : null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Senha"),
                        controller: _passController,
                        obscureText: true,
                        validator: (text) {
                          return (text.isEmpty || text.length < 6)
                              ? "Senha inválida!"
                              : null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Endereço"),
                        controller: _addressController,
                        keyboardType: TextInputType.streetAddress,
                        validator: (text) {
                          return text.isEmpty ? "Endereço inválido!" : null;
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              Map<String, dynamic> userData = {
                                "name": _nameController.text,
                                "email": _emailController.text,
                                "address": _addressController.text,
                              };

                              model.signUp(
                                  userData: userData,
                                  password: _passController.text,
                                  onSucces: _onSucess,
                                  onFail: _onFail);
                            }
                          },
                          child: Text(
                            "Cadastrar-se",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ));
            }
          },
        ));
  }

  void _onSucess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2))
        .then((_) => {Navigator.of(context).pop()});
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }
}

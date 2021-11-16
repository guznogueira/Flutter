import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Text(
                "Cadastrar-se",
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              )),
        ],
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
                      controller: _emailController,
                      decoration: InputDecoration(hintText: "email"),
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
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: "senha"),
                      obscureText: true,
                      validator: (text) {
                        return (text.isEmpty || text.length < 6)
                            ? "Senha inválida!"
                            : null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          if (_emailController.text.isEmpty) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  "Por favor informe o email para recuperar a senha!"),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 5),
                            ));
                          } else {
                            model.recoverPass(_emailController.text);
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  "Foi enviado um email para recuperar a senha!"),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 5),
                            ));
                          }
                        },
                        child: Text(
                          "Esqueci minha senha",
                          textAlign: TextAlign.right,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            model.signIn(
                                email: _emailController.text,
                                password: _passwordController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail);
                          }
                        },
                        child: Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ));
          }
        },
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao entrar!"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }
}

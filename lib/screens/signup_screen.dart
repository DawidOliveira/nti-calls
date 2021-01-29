import 'package:NTI_Calls/utils/app_routes.dart';
import 'package:NTI_Calls/widgets/button_widget.dart';
import 'package:NTI_Calls/widgets/input_field_widget.dart';
import 'package:NTI_Calls/widgets/input_pass_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isLoading = false;

  void _handleSubmit() {
    if (_emailController.text.isEmpty ||
        _passController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _confirmPassController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Preencha os campos corretamente!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (_passController.text == _confirmPassController.text) {
      setState(() {
        _isLoading = true;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      )
          .then((value) async {
        final fbm = FirebaseMessaging();
        final token = await fbm.getToken();
        FirebaseFirestore.instance.collection("users").doc(value.user.uid).set({
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "tokenSmartphone": token,
        }).then((_) {
          _emailController.clear();
          _passController.clear();
          _nameController.clear();
          _confirmPassController.clear();
          Navigator.of(context).pushReplacementNamed(AppRoutes.AUTHORHOME);
        });
      }).whenComplete(
        () => setState(() {
          _isLoading = false;
        }),
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('As senhas não são iguais!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputFieldWidget(
                          controller: _nameController,
                          hintText: 'Jorge Brasileiro',
                          text: 'Nome e Sobrenome',
                          textInputType: TextInputType.name,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InputFieldWidget(
                          controller: _emailController,
                          hintText: 'helpus@live.com',
                          textInputType: TextInputType.emailAddress,
                          text: 'E-mail',
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InputPassWidget(
                          controller: _passController,
                          hintText: '******',
                          text: 'Senha',
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InputPassWidget(
                          controller: _confirmPassController,
                          hintText: '******',
                          text: 'Confirme a senha',
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.LOGIN);
                            },
                            textColor: Theme.of(context).primaryColor,
                            child: Text('Já tem uma conta?'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ButtonWidget(
                  fn: _handleSubmit,
                  text: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text('CADASTRAR'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

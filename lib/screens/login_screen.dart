import 'package:NTI_Calls/utils/app_routes.dart';
import 'package:NTI_Calls/widgets/button_widget.dart';
import 'package:NTI_Calls/widgets/input_field_widget.dart';
import 'package:NTI_Calls/widgets/input_pass_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool _isLoading = false;

  void _handleSubmit() {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Preencha os campos corretamente!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
    )
        .then((value) async {
      final fbm = FirebaseMessaging();
      final token = await fbm.getToken();
      FirebaseFirestore.instance.collection("users").doc(value.user.uid).set({
        "tokenSmartphone": token,
      }, SetOptions(merge: true));
      _emailController.clear();
      _passController.clear();
      Navigator.of(context).pushReplacementNamed(AppRoutes.AUTHORHOME);
    }).whenComplete(
      () => setState(() {
        _isLoading = false;
      }),
    );
  }

  void _forgotPassword() {
    if (_emailController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Digite seu e-mail!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    FirebaseAuth.instance
        .sendPasswordResetEmail(
          email: _emailController.text.trim(),
        )
        .then((_) => _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content:
                    Text('Verifique seu e-mail para redefinição da sua senha!'),
                backgroundColor: Colors.green,
              ),
            ));
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
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                onPressed: _forgotPassword,
                                textColor: Theme.of(context).primaryColor,
                                child: Text('Esqueceu sua senha?'),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(AppRoutes.SIGNUP);
                                },
                                textColor: Theme.of(context).primaryColor,
                                child: Text('Não tem uma conta?'),
                              ),
                            ),
                          ],
                        )
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
                      : Text('ENTRAR'),
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

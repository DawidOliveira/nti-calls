import 'package:NTI_Calls/widgets/button_transparent_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _setores = ['Redes', 'Sistemas', 'Manutenção'];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  String _setor;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _localController = TextEditingController();

  void _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_setor == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Faltou escolher o setor!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (_textController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Faltou digitar o problema!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    final fbm = FirebaseMessaging();
    final _token = await fbm.getToken();
    FirebaseFirestore.instance.collection("calls").add({
      "setor": _setor,
      "problem": _textController.text.trim(),
      "local": _localController.text.trim(),
      "senderToken": _token,
      "created_at": DateTime.now(),
      "step": 1,
    }).then((_) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              'Só aguardar, em breve você será notificado(a) quando estivermos a caminho!'),
          backgroundColor: Colors.green,
        ),
      );
      _textController.clear();
      _localController.clear();
      setState(() {
        _setor = null;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              })
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 120,
              ),
              SizedBox(
                height: 60,
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _setor == null ? null : _setor,
                        hint: Text('Selecione um setor'),
                        iconEnabledColor: Colors.white,
                        items: _setores.map((e) {
                          return DropdownMenuItem<String>(
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _setor = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Digite o problema...',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 8,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextField(
                  controller: _localController,
                  decoration: InputDecoration(
                    hintText: 'Local: Bloco B, Biblioteca, etc...',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ButtonTransparentWidget(
                fn: _handleSubmit,
                text: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text('ENVIAR'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

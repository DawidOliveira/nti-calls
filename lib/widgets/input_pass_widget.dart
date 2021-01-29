import 'package:flutter/material.dart';

class InputPassWidget extends StatelessWidget {
  final String text;
  final String hintText;
  final TextEditingController controller;

  InputPassWidget({this.text, this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

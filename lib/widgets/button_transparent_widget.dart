import 'package:flutter/material.dart';

class ButtonTransparentWidget extends StatelessWidget {
  final Widget text;
  final Function fn;

  ButtonTransparentWidget({this.text, this.fn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 15),
      child: RaisedButton(
        onPressed: fn,
        child: text,
        color: Colors.transparent,
        textColor: Colors.white,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
      ),
    );
  }
}

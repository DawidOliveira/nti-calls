import 'package:NTI_Calls/utils/app_routes.dart';
import 'package:NTI_Calls/widgets/button_transparent_widget.dart';
import 'package:NTI_Calls/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            ),
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width / 2.5,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Column(
              children: [
                ButtonTransparentWidget(
                  fn: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.SIGNUP);
                  },
                  text: Text('CADASTRAR'),
                ),
                ButtonWidget(
                  fn: () {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);
                  },
                  text: Text('ENTRAR'),
                  color: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:NTI_Calls/screens/auth_or_home.dart';
import 'package:NTI_Calls/screens/home_screen.dart';
import 'package:NTI_Calls/screens/login_screen.dart';
import 'package:NTI_Calls/screens/onboarding_screen.dart';
import 'package:NTI_Calls/screens/signup_screen.dart';
import 'package:NTI_Calls/screens/splash_screen.dart';
import 'package:NTI_Calls/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _init = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: _init,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'NTI Chamados',
            theme: ThemeData(
              primaryColor: Color.fromRGBO(0, 148, 218, 1),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
            routes: {
              AppRoutes.AUTHORHOME: (_) => AuthOrHomeScreen(),
              AppRoutes.LOGIN: (_) => LoginScreen(),
              AppRoutes.ONBOARDING: (_) => OnboardingScreen(),
              AppRoutes.SIGNUP: (_) => SignUpScreen(),
              AppRoutes.HOME: (_) => HomeScreen(),
            },
          );
        });
  }
}

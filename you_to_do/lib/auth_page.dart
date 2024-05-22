import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_to_do/first.dart';
import 'package:you_to_do/home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user je ulogiran
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            return const HomePage();
          }
          // user nije ulogiran
          else {
            return const FirstPage();
          }
        },
      ),
    );
  }
}

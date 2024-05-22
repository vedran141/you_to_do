import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_to_do/home.dart';

Future<void> logIn(BuildContext context, TextEditingController emailController,
    TextEditingController passwordController) async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  // try
  try {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = credential.user;

    // ako su uneseni podaci
    if (user != null) {
      // reload za azuriranje firebase stanja da provjerimo usera
      await user.reload();

      // ako je user verificiran, ulazi u app
      if (user.emailVerified && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
      // ako nije verificiran, prikazuje se dialog
      else {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
                  title: const Text('Email not verified',
                      textAlign: TextAlign.center),
                  titleTextStyle: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                  content: const Text(
                      'You cannot log in until your email address is verified. Please check your email and verify your account.',
                      textAlign: TextAlign.justify),
                  contentTextStyle: GoogleFonts.ubuntu(
                      color: Colors.black, fontSize: 16, height: 1.5),
                  backgroundColor: Colors.white,
                  actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK',
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              );
            },
          );
        }
      }
    }
  }
  // on
  on FirebaseAuthException catch (e) {
    String errorText;
    if (e.code == 'wrong-password') {
      errorText = 'Wrong password, please enter the correct password.';
    } else if (e.code == 'invalid-email') {
      errorText = 'This email address is invalid. Try again.';
    } else if (e.code == 'user-not-found') {
      errorText = 'The user with this email address doesn\'t exist.';
    } else if (e.code == 'user-disabled') {
      errorText = 'The user with this email address has been disabled.';
    } else if (email == '' && password == '') {
      errorText = 'Please fill in the email and password fields.';
    } else if (email.isEmpty) {
      errorText = 'Please enter the email address.';
      emailController.clear();
    } else if (password.isEmpty) {
      errorText = 'Please enter the password.';
      passwordController.clear();
    } else {
      errorText =
          'Please connect to the internet to be able to log into the app.';
    }

    // dialog za prikazivanje errora kod unosa emaila/passworda
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Error', textAlign: TextAlign.center),
              titleTextStyle: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
              content: Text(
                errorText,
                textAlign: TextAlign.justify,
              ),
              contentTextStyle: GoogleFonts.ubuntu(
                  color: Colors.black, fontSize: 16, height: 1.5),
              backgroundColor: Colors.white,
              actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                )
              ],
            ),
          );
        },
      );
    }
  }
}

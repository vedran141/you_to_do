import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> passwordReset(
    BuildContext context, TextEditingController emailController) async {
  String email = emailController.text.trim();

  // try
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Email sent', textAlign: TextAlign.center),
              titleTextStyle: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
              content: Text(
                  'Password reset email sent to $email. Please check your email and reset your password.',
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
  // on
  on FirebaseAuthException catch (e) {
    String errorText;
    if (e.code == 'invalid-email') {
      errorText = 'This email address is invalid. Try again.';
    } else if (e.code == 'user-not-found') {
      errorText = 'No user found with this email address.';
    } else if (email.isEmpty) {
      errorText = 'Please enter the email address.';
      emailController.clear();
    } else {
      errorText =
          'Please connect to the internet so we can send you a password reset email.';
    }

    // dialog za prikazivanje errora kod unosa emaila
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Error'),
              titleTextStyle: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
              content: Text(errorText, textAlign: TextAlign.justify),
              contentTextStyle: GoogleFonts.ubuntu(
                  color: Colors.black, fontSize: 16, height: 1.5),
              backgroundColor: Colors.white,
              actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }
}

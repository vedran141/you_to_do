import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_to_do/signup_success.dart';

Future<void> signUp(BuildContext context, TextEditingController emailController,
    TextEditingController passwordController) async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  // try
  try {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // slanje maila za email verifikaciju
    await credential.user!.sendEmailVerification();

    // dialog kako je mail poslan i kako treba potvrditi svoj email
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Verification email sent'),
              titleTextStyle: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
              content: Text(
                  'A verification email has been sent to $email. Please verify your email before proceeding.',
                  textAlign: TextAlign.justify),
              contentTextStyle: GoogleFonts.ubuntu(
                  color: Colors.black, fontSize: 16, height: 1.5),
              backgroundColor: Colors.white,
              actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
              actions: [
                TextButton(
                  child: Text('OK',
                      style: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    FirebaseAuth.instance.authStateChanges().listen(
                      (User? user) async {
                        await credential.user!.reload();

                        // ako je user unio podatke i verificirao mail, logiran je i ulazi u app
                        if (user != null && user.emailVerified) {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          if (context.mounted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignupSuccessPage()));
                          }
                        }
                        // ako nije verificiran, dialog se prikaze i moze stisnuti ok, ali ostaje na ovom alertu sve dok se ne verificira
                        else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PopScope(
                                  canPop: false,
                                  child: AlertDialog(
                                    title: const Text('Email not verified'),
                                    titleTextStyle: GoogleFonts.ubuntu(
                                        color: Colors.black,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                    content: const Text(
                                        'Your email is not verified. Please verify your email before proceeding.',
                                        textAlign: TextAlign.justify),
                                    contentTextStyle: GoogleFonts.ubuntu(
                                        color: Colors.black,
                                        fontSize: 16,
                                        height: 1.5),
                                    backgroundColor: Colors.white,
                                    actionsPadding: const EdgeInsets.only(
                                        bottom: 10, right: 10),
                                    actions: [
                                      TextButton(
                                        child: Text('OK',
                                            style: GoogleFonts.ubuntu(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }
                      },
                    );
                  },
                ),
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
    if (e.code == 'weak-password') {
      errorText = 'Password should be at least 6 characters long.';
    } else if (e.code == 'email-already-in-use') {
      errorText = 'This email address is already in use.';
    } else if (e.code == 'invalid-email') {
      errorText = 'This email address is invalid.';
    } else if (email == '' && password == '') {
      errorText = 'Please fill in the email and password fields.';
    } else if (email.isEmpty) {
      errorText = 'Please enter the email address.';
      emailController.clear();
    } else if (password.isEmpty) {
      errorText = 'Please enter the password.';
      passwordController.clear();
    } else {
      errorText = 'Please connect to the internet to be able to sign up.';
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

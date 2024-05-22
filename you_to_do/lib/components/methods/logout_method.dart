import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_to_do/first.dart';

Future<void> logOut(BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;
  final String? email = user?.email!;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Warning', textAlign: TextAlign.center),
          titleTextStyle: GoogleFonts.ubuntu(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
          content: Text(
              'Are you sure you want to log out from the account with the email address: $email?',
              textAlign: TextAlign.justify),
          contentTextStyle: GoogleFonts.ubuntu(
              color: Colors.black, fontSize: 16, height: 1.5),
          backgroundColor: Colors.white,
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          actions: [
            TextButton(
              child: const Text('Yes',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              onPressed: () async {
                await _auth.signOut();

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FirstPage()),
                      (route) => false);
                }
              },
            ),
            TextButton(
              child: const Text('No',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    },
  );
}

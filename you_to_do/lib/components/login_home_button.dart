import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_to_do/login.dart';

class LoginHomeButton extends StatelessWidget {
  const LoginHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text("Log in",
              style: GoogleFonts.ubuntu(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

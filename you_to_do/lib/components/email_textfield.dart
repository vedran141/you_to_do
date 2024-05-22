import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MailTextfield extends StatelessWidget {
  final TextEditingController controller;

  const MailTextfield({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Email',
          hintStyle: GoogleFonts.ubuntu(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInput({super.key, required this.controller});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscuredPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextFormField(
        controller: widget.controller,
        obscureText: obscuredPassword,
        style: GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Password',
          hintStyle: GoogleFonts.ubuntu(),
          suffixIcon: IconButton(
            icon: obscuredPassword
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                obscuredPassword = !obscuredPassword;
              });
            },
          ),
        ),
      ),
    );
  }
}

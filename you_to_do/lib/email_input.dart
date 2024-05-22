import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_to_do/components/email_textfield.dart';
import 'package:you_to_do/components/methods/reset_password_method.dart';

class EmailInputPage extends StatefulWidget {
  const EmailInputPage({super.key});

  @override
  State<EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
      ),
      backgroundColor: const Color.fromARGB(255, 215, 245, 235),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // tekst
              Text('Enter your email address',
                  style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),

              // prazan prostor
              const SizedBox(height: 25),

              // unos emaila
              MailTextfield(controller: emailController),

              // prazan prostor
              const SizedBox(height: 25),

              // tipka Continue
              GestureDetector(
                onTap: () async {
                  await passwordReset(context, emailController);
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text("Continue",
                        style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

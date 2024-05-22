import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_to_do/components/email_textfield.dart';
import 'package:you_to_do/components/methods/login_method.dart';
import 'package:you_to_do/components/password_textfield.dart';
import 'package:you_to_do/email_input.dart';
import 'package:you_to_do/first.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscuredPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FirstPage()));
            }),
      ),
      backgroundColor: const Color.fromARGB(255, 225, 255, 245),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // tekst
              Text('Welcome back',
                  style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),

              // prazan prostor
              const SizedBox(height: 25),

              // unos emaila
              MailTextfield(controller: emailController),

              // prazan prostor
              const SizedBox(height: 15),

              // unos passworda
              PasswordInput(controller: passwordController),

              // prazan prostor
              const SizedBox(height: 10),

              // forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmailInputPage()));
                      },
                      child: Text('Forgot password?',
                          style: GoogleFonts.ubuntu(
                              color: const Color.fromARGB(255, 90, 90, 90),
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),

              // prazan prostor
              const SizedBox(height: 35),

              // tipka za login
              GestureDetector(
                onTap: () async {
                  await logIn(context, emailController, passwordController);
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text("Log in",
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

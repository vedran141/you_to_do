import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_to_do/components/login_home_button.dart';
import 'package:you_to_do/components/signup_home_button.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 225, 255, 245),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // logo
                    Image.asset(
                      'lib/images/you_to_do.png',
                      width: 125,
                      height: 125,
                    ),

                    // prazan prostor
                    const SizedBox(height: 25),

                    // poruka dobrodoslice
                    Text('Welcome to you to-do!',
                        style: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),

                    // prazan prostor
                    const SizedBox(height: 15),

                    // manja poruka
                    Text('Start writing the notes to your to-do list today!',
                        style: GoogleFonts.ubuntu(
                            color: Colors.grey, fontSize: 16)),

                    // prazan prostor
                    const SizedBox(height: 25),

                    // red u kojemu su tipke za signup i login
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 25)),
                        Expanded(child: SignupHomeButton()),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 25)),
                        Expanded(child: LoginHomeButton()),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 25))
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

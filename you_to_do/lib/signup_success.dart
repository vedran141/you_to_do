import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_to_do/home.dart';

class SignupSuccessPage extends StatelessWidget {
  const SignupSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 215, 245, 235),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ikona kvacice
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 100),

                    // prazan prostor
                    const SizedBox(height: 15),

                    // poruka
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Thanks for signing up to you to-do!',
                        style: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // prazan prostor
                    const SizedBox(height: 15),

                    // manja poruka
                    Text(
                      'Start adding the notes to your to-do list!',
                      style:
                          GoogleFonts.ubuntu(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),

                    // prazan prostor
                    const SizedBox(height: 25),

                    // tipka OK
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text("OK",
                                style: GoogleFonts.ubuntu(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

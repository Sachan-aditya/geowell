import 'package:flutter/material.dart';
import 'package:geowell/screens/user/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

// Assuming Loginscreen is correctly imported and defined elsewhere in your project.

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => logiApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Lottie.asset('assets/animation_lm9enjzd.json', height: 100),
        const SizedBox(
          height: 30,
        ),
            Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.blue[300]!,
              child: Text(
                "GEOWELL ADVISOR", // Updated text here
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



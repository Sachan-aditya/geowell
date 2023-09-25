import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'user/login.dart';
void main() {
  runApp(const welcomeApp());
}

// ignore: camel_case_types
class welcomeApp extends StatelessWidget {
  const welcomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GeoWell',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: 
          Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          const SizedBox(height: 150,),
            Text(
              "GEOWELL",
              style: GoogleFonts.montserrat(
                  color:Colors.blueAccent,
                  fontSize: 42,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "ADVISOR",
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10,),
            Lottie.asset('assets/animation_lm9enjzd.json',height: 100),
            const SizedBox(height: 30,),
          Center(
                  
                    child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32.0),
                                  
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                                  maximumSize: const Size.fromHeight(double.infinity),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                        child:  const Text('Get Started!')),
                                  ),
                  ),
              
            
       ] ),
     
    );
  }
}

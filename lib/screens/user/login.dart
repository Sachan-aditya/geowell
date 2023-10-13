import 'dart:io';
import 'dart:developer';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geowell/screens/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  void googleButton() {
    Dialogs.showProgressbar(context);

    signInWithGoogle().then((user) {
      Navigator.pop(context);
      if (user != null) {
        log('User: ${user.user?.displayName ?? user.user?.email ?? "Unknown"}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>HomePage())
        );
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackbar(context, "No Internet Connection");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 241, 214),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: mq.height * 0.3,
              left: mq.width * 0.25,
              width: mq.width * 0.5,
              child: Image.asset('assets/bat.png'),
            ),
            Positioned(
              top: mq.height * 0.6,
              left: mq.width * 0.16,
              width: mq.width * 0.7,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SignInScreen()),
                  );
                },
                icon: const Icon(Icons.mail, size: 50, color: Colors.black),
                label: const Text(
                  "Login with E-Mail",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor:Colors.white,
                ),
              ),
            ),
            Positioned(
              top: mq.height * 0.7,
              left: mq.width * 0.16,
              width: mq.width * 0.7,
              child: ElevatedButton.icon(
                onPressed: googleButton,
                icon: Image.asset('assets/download.png'),
                label: const Text(
                  "Login with Google",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  shadowColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geowell/screens/home.dart';
import 'package:geowell/screens/tani.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const logiApp());
}

class logiApp extends StatelessWidget {
  const logiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Geowell',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
  }

  Future<void> _checkLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool loggedIn = prefs.getBool('loggedIn') ?? false;
    if (loggedIn) {
      _navigateToHomePage();
    }
  }

  void _navigateToHomePage() {
    setState(() {
      _isLoggedIn = true;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _showLoginResultDialog(bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Login Successful' : 'Login Failed'),
          content: Text(
            success
                ? 'You have successfully logged in.'
                : 'Login failed. Try Login with Email.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.blue[300]!,
              child: Text(
                "Connect With US !", // Updated text here
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: const Color.fromARGB(255, 255, 196, 108),
              highlightColor: Colors.white,
              child: Text(
                "भारत का अपना एप", // Updated text here
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/first.png',
              height: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const  LogApp()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Login with Email',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (!_isLoggedIn)
              ElevatedButton(
                onPressed: () async {
                  try {
                    final GoogleSignInAccount? googleUser =
                        await GoogleSignIn().signIn();

                    if (googleUser == null) {
                      return;
                    }

                    final GoogleSignInAuthentication googleAuth =
                        await googleUser.authentication;
                    final AuthCredential credential =
                        GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );

                    final UserCredential authResult =
                        await FirebaseAuth.instance.signInWithCredential(
                            credential);
                    final User? user = authResult.user;

                    if (user != null) {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('loggedIn', true);

                      _showLoginResultDialog(true);

                      _navigateToHomePage();
                    } else {
                      _showLoginResultDialog(false);
                    }
                  } catch (e) {
                    _showLoginResultDialog(false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://img.icons8.com/?size=96&id=V5cGWnc9R4xj&format=png',
                      width: 20,
                    ),
                    const SizedBox(width: 8.0),
                    const Text(
                      'Login with Google',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

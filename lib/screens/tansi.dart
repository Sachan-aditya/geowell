import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geowell/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const signupApp());
}

// ignore: camel_case_types
class signupApp extends StatelessWidget {
  const signupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GeoWell',
      debugShowCheckedModeBanner: false,
      home: SignupPage(),
    );
  }
}
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/clock.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/light-2.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/clock.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: const Center(
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .2),
                          blurRadius: 20.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, .6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: _signup, // Call the signup function when the button is pressed
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signup() async {
    // Validate the email and password before attempting registration
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // If email or password is empty, show a pop-up
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('Please enter both email and password.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        _saveCredentials(); // Save credentials when sign-up is successful
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );

        // Show a pop-up to indicate successful sign-up
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Successful'),
            content: const Text('You have been registered successfully!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
     
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('Sign-up failed. Password should have 6 digits'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
  }
}

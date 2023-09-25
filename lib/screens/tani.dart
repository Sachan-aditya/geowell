import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geowell/screens/home.dart';
import 'package:geowell/screens/tansi.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const LogApp());
}

class LogApp extends StatelessWidget {
  const LogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GeoWell',
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedEmail = prefs.getString('email') ?? '';
    String savedPassword = prefs.getString('password') ?? '';

    setState(() {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
    });
  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
  }

  Future<void> _login() async {
    setState(() {
      // Set loading state to true
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        // Save user's email and password in shared preferences
        _saveCredentials();

        // Save the login status as true
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);

        // Pop login page
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

        // Show a dialog to indicate successful login
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Successful'),
            content: const Text('User logged in successfully!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle login errors here (e.g., display an error message).
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Failed to log in. Please try again.'),
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
    } finally {
      setState(() {
        // Set loading state to false
      });
    }
  }

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
                          image: AssetImage('assets/images/light-1.png'),
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
                          image: AssetImage('assets/clock.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: const Center(
                        child: Text(
                          "Login",
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
                                bottom: BorderSide(color: Colors.grey)),
                          ),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle:
                                  TextStyle(color: Colors.grey[400]),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle:
                                  TextStyle(color: Colors.grey[400]),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blueGrey,
                          Colors.blue,
                        ],
                      ),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () => _login(),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupPage()));
                    },
                    child: const Text("New User ? Create Account",
                        style: TextStyle(
                            color: Color.fromRGBO(143, 148, 251, 1))),
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


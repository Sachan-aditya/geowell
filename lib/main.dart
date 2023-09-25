import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geowell/firebase_options.dart';
import 'package:geowell/screens/home.dart';
import 'package:geowell/screens/tani.dart';
import 'package:geowell/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if the user is logged in and set the initial route accordingly
  bool userLoggedIn = await isLoggedIn();
  String initialRoute = userLoggedIn ? '/homeyApp' : '/welcome';

  runApp(
    ProviderScope(
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

Future<void> loginUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
}

Future<void> logoutUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
}

Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoWell',
      initialRoute: initialRoute,
      routes: {
        '/welcome': (context) => const welcomeApp(),
        '/signup': (context) => const LogApp(),
        '/homeyApp': (context) => FutureBuilder<bool>(
              future: isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
        
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final isLoggedIn = snapshot.data!;
                  return WillPopScope(
                    onWillPop: () async {
                      if (isLoggedIn) {
                       
                        return false;
                      } else {
                        
                        return true;
                      }
                    },
                    child: const HomeyApp(),
                  );
                } else {
                  
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
              },
            ),
      },
    );
  }
}
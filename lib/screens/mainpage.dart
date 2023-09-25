import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geowell/screens/user/csc.dart';
import 'package:geowell/screens/user/places.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator.pop()

void main() {
  runApp(const CustomNavBarApp());
}

class CustomNavBarApp extends StatelessWidget {
  const CustomNavBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geowell',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class CustomNavBarPage extends StatefulWidget {
  const CustomNavBarPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomNavBarPageState createState() => _CustomNavBarPageState();
}

class _CustomNavBarPageState extends State<CustomNavBarPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Image.asset('assets/post.png'),
        backgroundColor: Colors.black45,
        title: Text(
          'GEOWELL ADVISOR',
          style: GoogleFonts.openSans(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 87, 145, 244),
          ),
        ),
        elevation: 3,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          AddScreen(),
          HomeScreen(),
          UserPanelApp(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blueAccent,
        mouseCursor: SystemMouseCursors.alias,
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              'assets/icons8-home-48 (1).png',
              height: 30,
            ),
            icon: Image.asset(
              'assets/icons8-home-48.png',
              height: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black87,
            activeIcon: Image.asset(
              'assets/icons8-add-48 (1).png',
              height: 30,
            ),
            icon: Image.asset(
              'assets/icons8-add-48.png',
              height: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black26,
            activeIcon: Image.asset(
              'assets/icons8-user-48 (1).png',
              height: 30,
            ),
            icon: Image.asset(
              'assets/icons8-user-48.png',
              height: 30,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  final List<String> _photos = [
    'assets/EDmyJMSU8AYq1Vf.jpg',
    'assets/15-aug-2022-banner.jpg',
    'assets/JSACTR-LaunchAd2.jpg',
  ];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Start a timer to automatically slide photos every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < _photos.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _photos.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(_photos[index],
                        height: 10, fit: BoxFit.fill);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.black54,
            child: const Text(
              "Select Below to See Data",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 250,
            width: 300,
            child: MyHomeApp(),
          ),
          Lottie.asset('assets/animation_lmwdp980.json', height: 200),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PlacesScreen();
  }
}

class UserPanelApp extends StatelessWidget {
  const UserPanelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoWell',
      home: UserPanel(),
    );
  }
}

class UserPanel extends StatelessWidget {
  const UserPanel({
    Key? key,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    // Clear all data in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Exit the app completely
    SystemNavigator.pop(); // This line will close the app
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            title: Text(
              'About Us',
              style: GoogleFonts.openSans(color: Colors.blue),
            ),
            onTap: () {
              // Navigate to About Us page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: Text(
              'Sign Out',
              style: GoogleFonts.openSans(color: Colors.blue),
            ),
            onTap: () {
              // Call the sign-out function
              _signOut(context);
            },
          ),
        ],
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animation_lmwd0zqo.json', height: 200),
            const SizedBox(
              height: 60,
            ),
            const Text("TANISHQ AGARWAL(Team Leader)",
                style: TextStyle(color: Colors.white)),
            const Text("AYUSHI SINGH", style: TextStyle(color: Colors.blue)),
            const Text("AVNI JAIN", style: TextStyle(color: Colors.white)),
            const Text("SATYAM SINGH", style: TextStyle(color: Colors.blue)),
            const Text("SATYAM ", style: TextStyle(color: Colors.white)),
            const Text("ADITYA SACHAN", style: TextStyle(color: Colors.blue)),
            const Spacer(
              flex: 3,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "MADE WITH",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              const Icon(
                CupertinoIcons.heart_fill,
                color: Colors.red,
              ),
              Text(
                "by Aditya Sachan",
                style: GoogleFonts.caveat(
                    color: Colors.white,
                    textStyle: const TextStyle(fontSize: 23)),
              )
            ]),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the SystemNavigator class
import 'package:geowell/screens/mainpage.dart';

import 'package:geowell/widgets/location_input.dart';
import '../model/place.dart';
import '../widgets/charts.dart';

void main() {
  runApp(const HomeyApp());
}

class HomeyApp extends StatelessWidget {
  const HomeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GeoWell',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  get onSelectLocation => null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Handle the back button press
      onWillPop: () async {
        // Exit the app when the back button is pressed on the HomePage
        SystemNavigator.pop();
        return true; // Return true to prevent further back navigation
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: LocationInput(
                    onSelectLocation: (PlaceLocation location) {},
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => cMyApp()),
                  );
                },
                child: const Text("SHOW DATA"),
              ),
              const SizedBox(height: 10,),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomNavBarPage()),
                  );
                },
                child: const Text("SKIP FOR NOW"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

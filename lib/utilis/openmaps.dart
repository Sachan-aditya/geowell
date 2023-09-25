import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';


// ignore: use_key_in_widget_constructors
class MyMapPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  LatLong? currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Current Location:',
              style: TextStyle(fontSize: 18),
            ),
            currentLocation != null
                ? Text(
                    'Latitude: ${currentLocation!.latitude}, Longitude: ${currentLocation!.longitude}',
                    style: const TextStyle(fontSize: 18),
                  )
                : const Text(
                    'Location not set',
                    style: TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 20),
            OpenStreetMapSearchAndPick(
              center: currentLocation ?? const LatLong(24.447399, 77.192101),
              buttonColor: Colors.orange,
              buttonText: 'Set Current Location',
              onPicked: (pickedData) {
                setState(() {
                  currentLocation = pickedData as LatLong?;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyMapPage(),
  ));
}

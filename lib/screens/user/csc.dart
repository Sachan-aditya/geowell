import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:geowell/widgets/charts.dart';



class MyHomeApp extends StatefulWidget {
  const MyHomeApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomeAppState createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  String selectedCountry = "India"; // Set the initial selected country

  @override
  void initState() {
    super.initState();

    // Set the initial selected country using the ISO code
    selectedCountry = "IN"; // ISO code for India
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.black,
                padding: const EdgeInsets.all(20),
                child: CSCPicker(
                  layout: Layout.horizontal,
                  // ignore: non_constant_identifier_names
                  onCountryChanged: (India) {
                    setState(() {
                      selectedCountry =India ;
                    });
                  },
                  onStateChanged: (value) {
                  },
                  onCityChanged: (value) {
                  },
                ),
              ),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.push
                  (
                      context,
                      MaterialPageRoute(
                        builder: (context) =>const cMyApp(),
                      ));
                },style:ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
                child: const Text("SHOW"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

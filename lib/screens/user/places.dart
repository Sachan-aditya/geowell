// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: library_prefixes
import 'package:geowell/model/user_places.dart' as userPlacesModel; // Use 'as' to create a prefix
import 'package:geowell/screens/user/add_place.dart';
import 'package:geowell/widgets/places_list.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesModel.userPlacesProvider.notifier).loadPlaces(); // Use the prefix here
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesModel.userPlacesProvider); // Use the prefix here

    return Scaffold(
     
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const AddPlaceScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : PlacesList(
                      places: userPlaces,
                    ),
        ),
      ),
    );
  }
}

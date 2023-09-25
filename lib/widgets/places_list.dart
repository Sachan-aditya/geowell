import 'package:flutter/material.dart';
import 'package:geowell/model/place.dart';
import 'package:geowell/screens/user/place_detail.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package

class PlacesList extends StatefulWidget {
  final List<Place> places;

  PlacesList({Key? key, required this.places}) : super(key: key);

  @override
  _PlacesListState createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  late SharedPreferences _prefs;
  List<Place> _savedPlaces = [];

  @override
  void initState() {
    super.initState();
    _loadSavedPlaces();
  }

  Future<void> _loadSavedPlaces() async {
    _prefs = await SharedPreferences.getInstance();
    final savedPlaceIds = _prefs.getStringList('savedPlaceIds') ?? [];
    setState(() {
      _savedPlaces = widget.places.where((place) {
        return savedPlaceIds.contains(place.id); // Assuming each Place has an "id" property.
      }).toList();
    });
  }

  Future<void> _toggleSaved(Place place) async {
    setState(() {
      if (_savedPlaces.contains(place)) {
        _savedPlaces.remove(place);
      } else {
        _savedPlaces.add(place);
      }
    });

    final savedPlaceIds = _savedPlaces.map((place) => place.id).toList();
    await _prefs.setStringList('savedPlaceIds', savedPlaceIds);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return const Center(
        child: Text(
          'No places added yet',
          style: TextStyle(color: Colors.black12),
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.places.length,
      itemBuilder: (ctx, index) {
        final place = widget.places[index];
        final isSaved = _savedPlaces.contains(place);

        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(place.image),
          ),
          title: Text(
            place.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          subtitle: Text(
            place.location.address,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          trailing: IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? Colors.red : null,
            ),
            onPressed: () {
              _toggleSaved(place);
            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlacesDetailScreen(place: place),
              ),
            );
          },
        );
      },
    );
  }
}

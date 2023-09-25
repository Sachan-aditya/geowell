import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geowell/model/user_places.dart';
import 'package:geowell/widgets/image_input.dart';
import 'package:geowell/widgets/location_input.dart';

import '../../model/place.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, _selectedImage!, _selectedLocation!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
              
                decoration: const InputDecoration(labelText: 'Title',fillColor: Colors.white,filled: true),
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 40),
              ImageInput(
                onPickedImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(height: 40),
              LocationInput(
                onSelectLocation: (location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              )
            ],
          ),
        ));
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:map_location_picker/map_location_picker.dart';

class MapPicker extends StatelessWidget {
  const MapPicker({super.key, required this.position});
  final LatLng position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MapLocationPicker(
          apiKey: 'AIzaSyATYdg2D8GeBt7Kg6Y7PlkY56jTvc__RTc',
          currentLatLng: position,
          desiredAccuracy: LocationAccuracy.best,
          onNext: (GeocodingResult? result) {
            Get.back(
              result: LatLng(
                result!.geometry.location.lat,
                result.geometry.location.lng,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MapPickerLocation extends StatelessWidget {
  const MapPickerLocation({super.key, required this.position});
  final LatLng position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MapLocationPicker(
          apiKey: 'AIzaSyATYdg2D8GeBt7Kg6Y7PlkY56jTvc__RTc',
          currentLatLng: position,
          desiredAccuracy: LocationAccuracy.best,
          onNext: (GeocodingResult? result) {
            final data = {
              'lat': result!.geometry.location.lat,
              'lng': result.geometry.location.lng,
              'address': result.formattedAddress,
            };
            Get.back(
              result: data,
            );
          },
        ),
      ),
    );
  }
}

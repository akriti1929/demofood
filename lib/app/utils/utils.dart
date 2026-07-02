// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/osm_place_picker/osm_location_picker_screen.dart';
import 'package:admin_panel/app/constant/place_picker/location_picker_screen.dart';
import 'package:admin_panel/app/constant/place_picker/selected_location_model.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../constant/constants.dart';

class Utils {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.requestPermission();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    while (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        ShowToastDialog.errorToast("Permission Required.\nPlease allow location to continue.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ShowToastDialog.errorToast("Permission Required.\nLocation permission is permanently denied. Please enable it from Settings.");
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  static Future<SelectedLocationModel?> showPlacePicker(BuildContext context) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Constant.selectedMap == "Google Map" ? const LocationPickerScreen() : const OsmLocationPickerScreen();
        },
      ),
    );
  }
}

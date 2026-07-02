import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:admin_panel/app/constant/place_picker/selected_location_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class OsmLocationPickerController extends GetxController {
  final MapController mapController = MapController();

  var selectedLocation = Rxn<LatLng>();
  var address = "Move the map to select a location".obs;

  TextEditingController searchController = TextEditingController();
  RxList<Map<String, dynamic>> suggestions = <Map<String, dynamic>>[].obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latLng = LatLng(pos.latitude, pos.longitude);
    selectedLocation.value = latLng;

    mapController.move(latLng, 15);
    await getAddressFromLatLng(latLng);
  }

  /// ✅ THIS IS THE KEY FIX
  void onMapMoved(LatLng center, bool hasGesture) {
    if (!hasGesture) return;

    selectedLocation.value = center;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      getAddressFromLatLng(center);
    });
  }

  Future<void> searchPlace(String query) async {
    if (query.length < 2) {
      suggestions.clear();
      return;
    }

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search"
      "?q=$query&format=json&addressdetails=1&limit=10",
    );

    final res = await http.get(
      url,
      headers: {'User-Agent': 'admin-panel'},
    );

    suggestions.value = List<Map<String, dynamic>>.from(json.decode(res.body));
  }

  void selectSuggestion(Map<String, dynamic> place) async {
    final latLng = LatLng(
      double.parse(place['lat']),
      double.parse(place['lon']),
    );

    selectedLocation.value = latLng;
    searchController.text = place['display_name'];

    mapController.move(latLng, 16);
    await getAddressFromLatLng(latLng);
    suggestions.clear();
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse"
      "?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}",
    );

    final res = await http.get(
      url,
      headers: {'User-Agent': 'admin-panel'},
    );

    final data = json.decode(res.body);
    address.value = data['display_name'] ?? "Address not found";
  }

  void confirmLocation() {
    if (selectedLocation.value == null) return;

    final model = SelectedLocationModel(
      latitude: selectedLocation.value!.latitude,
      longitude: selectedLocation.value!.longitude,
      address: address.value,
    );

    log("Selected: ${model.toJson()}");
    Get.back(result: model);
  }
}

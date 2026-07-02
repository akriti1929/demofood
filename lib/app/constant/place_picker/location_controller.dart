// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/place_picker/selected_location_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  GoogleMapController? mapController;
  var selectedLocation = Rxn<LatLng>();
  var address = "Move the map to select a location".obs;
  TextEditingController searchController = TextEditingController();
  var predictions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    searchController.addListener(() {
      if (searchController.text.trim().isEmpty) {
        getCurrentLocation();
        predictions.clear();
      }
    });
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    selectedLocation.value = LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedLocation.value!, zoom: 15),
      ),
    );

    getAddressFromLatLng(selectedLocation.value!);
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json"
        "?latlng=${latLng.latitude},${latLng.longitude}"
        "&key=${Constant.googleMapKey}",
      );

      final res = await http.get(url);
      final data = json.decode(res.body);

      address.value = data['results']?[0]?['formatted_address'] ?? "Address not found";
    } catch (e) {
      address.value = "Unable to fetch address";
    }
  }

  void fetchPredictions(String input) {
    if (!kIsWeb || input.isEmpty) {
      predictions.clear();
      return;
    }

    final service = js.context['google']['maps']['places']
    ['AutocompleteService'];

    final jsService = js.JsObject(service);

    jsService.callMethod('getPlacePredictions', [
      js.JsObject.jsify({'input': input}),
          (result, status) {
        if (result != null) {
          predictions.value = List<Map<String, dynamic>>.from(
            result.map((e) => {
              'description': e['description'],
              'place_id': e['place_id'],
            }),
          );
        }
      }
    ]);
  }

  void selectPrediction(Map<String, dynamic> prediction) {
    final mapDiv = html.DivElement();
    final service = js.JsObject(
      js.context['google']['maps']['places']['PlacesService'],
      [mapDiv],
    );

    service.callMethod('getDetails', [
      js.JsObject.jsify({'placeId': prediction['place_id']}),
          (place, status) {
        if (place != null) {
          final lat = place['geometry']['location'].callMethod('lat');
          final lng = place['geometry']['location'].callMethod('lng');

          final target = LatLng(lat, lng);
          selectedLocation.value = target;
          searchController.text = prediction['description'];

          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(target, 15),
          );

          getAddressFromLatLng(target);
          predictions.clear();
        }
      }
    ]);
  }

  void onMapMoved(CameraPosition position) {
    selectedLocation.value = position.target;
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

  void moveCameraTo(LatLng target) {
    selectedLocation.value = target;
    mapController?.animateCamera(CameraUpdate.newLatLng(target));
    getAddressFromLatLng(target);
  }
}

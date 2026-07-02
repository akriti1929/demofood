// ignore_for_file: invalid_use_of_protected_member, depend_on_referenced_packages, deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:developer';

import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/zone_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as osmMap;
import 'package:latlong2/latlong.dart' as osmLatLng;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:js' as js;
import 'dart:html' as html;

import 'package:http/http.dart' as http;

class CreateZoneController extends GetxController {
  RxString title = 'Draw Business Zone'.tr.obs;

  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  RxString editingId = "".obs;

  Rx<TextEditingController> zoneController = TextEditingController().obs;
  Rx<ZoneModel> zoneModel = ZoneModel().obs;

  osmMap.MapController? osmMapController;
  GoogleMapController? googleMapController;

  RxList<LatLng> polygonCoords = <LatLng>[].obs;
  RxSet<Polygon> polygons = <Polygon>{}.obs;
  RxSet<Marker> markers = <Marker>{}.obs;
  TextEditingController searchController = TextEditingController();
  var predictions = <Map<String, dynamic>>[].obs;
  var selectedLocation = Rxn<LatLng>();
  var address = "Move the map to select a location".obs;

  osmLatLng.LatLng toOsm(LatLng g) => osmLatLng.LatLng(g.latitude, g.longitude);

  @override
  Future<void> onInit() async {
    osmMapController = osmMap.MapController();
    getArgument();
    Constant.currentLocation = await Utils.getCurrentLocation();
    super.onInit();
  }

  Future<void> getArgument() async {
    isLoading.value = true;
    try {
      String? zoneId = Get.parameters['zoneId'];

      if (zoneId == null || zoneId.isEmpty) {
        // Add mode
        setDefaultData();
        isLoading.value = false;
        return;
      }

      // Edit mode
      final value = await FireStoreUtils.getZoneByZoneId(zoneId);
      if (value != null) {
        zoneModel.value = value;
        editingId.value = zoneModel.value.id!;
        zoneController.value.text = zoneModel.value.name!;
        isActive.value = zoneModel.value.status!;
        polygonCoords.clear();

        if (zoneModel.value.area != null) {
          for (var geo in zoneModel.value.area!) {
            if (geo is GeoPoint) {
              polygonCoords.add(LatLng(geo.latitude, geo.longitude));
            }
          }

          final polygon = Polygon(
              polygonId: const PolygonId("zone"), points: polygonCoords, strokeColor: Colors.black, fillColor: Colors.black.withOpacity(0.2), strokeWidth: 3, geodesic: true);
          polygons.value = {polygon};
          markers.clear();
          for (int i = 0; i < polygonCoords.length; i++) {
            markers.add(
              Marker(
                markerId: MarkerId("point_$i"),
                position: polygonCoords[i],
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
              ),
            );
          }
        }
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log("Error in getArgument: $e");
    }
  }

  void addPolygon(LatLng position) {
    polygonCoords.add(position);

    polygons.clear();
    final polygon =
        Polygon(polygonId: const PolygonId("zone"), points: polygonCoords, strokeColor: Colors.black, fillColor: Colors.black.withOpacity(0.2), strokeWidth: 3, geodesic: true);
    polygons.value = {polygon};
    markers.clear();
    for (int i = 0; i < polygonCoords.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId("point_$i"),
          position: polygonCoords[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        ),
      );
    }
  }

  void addPolygonOSM(osmLatLng.LatLng point) {
    addPolygon(
      LatLng(point.latitude, point.longitude),
    );
  }

  void clearPolygon() {
    polygonCoords.clear();
    polygons.clear();
    markers.clear();
  }

  Future<void> addZone() async {
    if (polygonCoords.length < 3) {
      ShowToastDialog.errorToast("Please draw a polygon with at least 3 points.".tr);
      return;
    }

    Constant.waitingLoader();
    zoneModel.value.status = isActive.value;
    zoneModel.value.name = zoneController.value.text;
    zoneModel.value.area = polygonCoords.map((latLng) => GeoPoint(latLng.latitude, latLng.longitude)).toList();
    zoneModel.value.createdAt = Timestamp.now();
    if (editingId.value.isNotEmpty) {
      zoneModel.value.id = editingId.value;
      bool updated = await FireStoreUtils.updateZone(zoneModel.value);
      if (updated) {
        Get.back();
        Get.back(result: true);
        setDefaultData();
        ShowToastDialog.successToast("Zone Update..".tr);
      } else {
        ShowToastDialog.errorToast("Something went wrong, Please try later!".tr);
        isLoading.value = false;
      }
    } else {
      zoneModel.value.id = Constant.getRandomString(20);
      bool isSaved = await FireStoreUtils.addZones(zoneModel.value);
      if (isSaved) {
        Get.back();
        Get.back(result: true);
        setDefaultData();
        ShowToastDialog.successToast("Zone Create Successfully".tr);
      } else {
        ShowToastDialog.errorToast("Something went wrong, Please try later!".tr);
        isLoading.value = false;
      }
    }
  }

  void moveCameraToPolygon() {
    if (polygonCoords.isEmpty || googleMapController == null) return;

    LatLngBounds bounds = _getBounds(polygonCoords);

    googleMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50), // 50 is padding
    );
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double south = points.first.latitude;
    double north = points.first.latitude;
    double west = points.first.longitude;
    double east = points.first.longitude;

    for (LatLng point in points) {
      if (point.latitude < south) south = point.latitude;
      if (point.latitude > north) north = point.latitude;
      if (point.longitude < west) west = point.longitude;
      if (point.longitude > east) east = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  void fetchPredictions(String input) {
    if (!kIsWeb || input.isEmpty) {
      predictions.clear();
      return;
    }

    final service = js.JsObject(
      js.context['google']['maps']['places']['AutocompleteService'],
    );

    service.callMethod('getPlacePredictions', [
      js.JsObject.jsify({
        'input': input,
        'types': ['(cities)'], // 🔴 only cities
      }),
      (result, status) {
        if (result != null) {
          final list = <Map<String, dynamic>>[];
          for (var item in result) {
            list.add({
              'description': item['description'],
              'place_id': item['place_id'],
            });
          }
          predictions.value = list;
        } else {
          predictions.clear();
        }
      }
    ]);
  }

  void selectPrediction(Map<String, dynamic> prediction) {
    final placeId = prediction['place_id'];
    final description = prediction['description'];

    final mapDiv = html.DivElement();
    final service = js.JsObject(js.context['google']['maps']['places']['PlacesService'], [mapDiv]);
    service.callMethod('getDetails', [
      js.JsObject.jsify({'placeId': placeId}),
      (placeResult, status) {
        if (placeResult != null) {
          final lat = placeResult['geometry']['location'].callMethod('lat');
          final lng = placeResult['geometry']['location'].callMethod('lng');
          selectedLocation.value = LatLng(lat, lng);
          searchController.text = description;
          moveCameraTo(LatLng(lat, lng));
          predictions.clear(); // hide dropdown
        }
      }
    ]);
  }

  void moveCameraTo(LatLng target) {
    selectedLocation.value = target;
    if (Constant.selectedMap == "Google Map") {
      googleMapController?.animateCamera(
        CameraUpdate.newLatLngZoom(target, 15),
      );
    } else {
      moveCameraToOSM(target);
    }
    getAddressFromLatLng(target);
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      if (Constant.selectedMap == "Google Map" && kIsWeb) {
        /// GOOGLE (PAID)
        final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json"
          "?latlng=${latLng.latitude},${latLng.longitude}"
          "&key=${Constant.googleMapKey}",
        );

        final res = await http.get(url);
        final data = json.decode(res.body);

        address.value = data['results']?[0]?['formatted_address'] ?? "Address not found";
      } else {
        /// OSM – NOMINATIM (FREE)
        final url = Uri.parse(
          "https://nominatim.openstreetmap.org/reverse"
          "?format=json"
          "&lat=${latLng.latitude}"
          "&lon=${latLng.longitude}",
        );

        final res = await http.get(
          url,
          headers: {'User-Agent': 'admin-panel'},
        );

        final data = json.decode(res.body);
        address.value = data['display_name'] ?? "Address not found";
      }
    } catch (e) {
      address.value = "Unable to fetch address";
    }
  }

  void moveCameraToPolygonOSM() {
    if (polygonCoords.isEmpty) return;

    double south = polygonCoords.first.latitude;
    double north = polygonCoords.first.latitude;
    double west = polygonCoords.first.longitude;
    double east = polygonCoords.first.longitude;

    for (final p in polygonCoords) {
      if (p.latitude < south) south = p.latitude;
      if (p.latitude > north) north = p.latitude;
      if (p.longitude < west) west = p.longitude;
      if (p.longitude > east) east = p.longitude;
    }

    final bounds = osmMap.LatLngBounds(
      osmLatLng.LatLng(south, west),
      osmLatLng.LatLng(north, east),
    );

    osmMapController!.fitCamera(
      osmMap.CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  void moveCameraToOSM(LatLng target) {
    osmMapController!.move(
      toOsm(target),
      15,
    );
  }

  void setDefaultData() {
    zoneController.value.text = "";
    isActive.value = true;
    polygonCoords.clear();
    polygons.clear();
  }
}

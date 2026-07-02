
class SelectedLocationModel {
  String? address;
  double? latitude;
  double? longitude;

  SelectedLocationModel({this.address, this.latitude, this.longitude});

  SelectedLocationModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

// class SelectedLocationModel {
//   String? address;
//   LatLng? latLng;
//
//   SelectedLocationModel({this.address, this.latLng});
//
//   SelectedLocationModel.fromJson(Map<String, dynamic> json) {
//     final addressMap = json['address'];
//     final latLngJson = json['latLng'];
//     if (latLngJson != null) {
//       if (latLngJson is Map) {
//         latLng = LatLng(latLngJson['latitude'], latLngJson['longitude']);
//       } else if (latLngJson is List && latLngJson.length == 2) {
//         latLng = LatLng(latLngJson[0], latLngJson[1]);
//       }
//     }
//   }
//
//   String getFullAddress() {
//     return address ?? "No address selected".tr;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['address'] = address;
//     data['latLng'] = latLng == null
//         ? null
//         : {
//             'latitude': latLng!.latitude,
//             'longitude': latLng!.longitude,
//           };
//     return data;
//   }
// }

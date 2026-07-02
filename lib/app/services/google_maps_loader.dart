import 'dart:html' as html;
import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/models/constant_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';

class GoogleMapsLoader {
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    final doc = await FireStoreUtils.fireStore.collection(CollectionName.settings).doc('constant').get();
    if (!doc.exists) {
      throw Exception('Google Maps config document not found');
    }
    ConstantModel constantModel = ConstantModel.fromJson(doc.data()!);
    final apiKey = constantModel.mapSettings!.googleMapKey;
    print("Map Key:::$apiKey");
    if (apiKey == null || apiKey
        .toString()
        .isEmpty) {
      throw Exception('googleMapKey is missing in Firestore');
    }
    // :earth_africa: Inject Google Maps JS
    final script = html.ScriptElement()
      ..src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey&libraries=places&loading=async'
      ..type = 'application/javascript'
      ..defer = true
      ..async = true;
    html.document.head!.append(script);
    _loaded = true;
  }
}

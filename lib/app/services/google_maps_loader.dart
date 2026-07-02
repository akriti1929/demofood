import 'dart:html' as html;
import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/models/constant_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';

class GoogleMapsLoader {
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    try {
      // Bypassing because dummy Firebase config will cause get() to hang forever
      // final doc = await FireStoreUtils.fireStore.collection(CollectionName.settings).doc('constant').get();
      // ConstantModel constantModel = ConstantModel.fromJson(doc.data()!);
      // final apiKey = constantModel.mapSettings!.googleMapKey;
      throw Exception('Bypassed for local dummy setup');
    } catch (e) {
      print("Google Maps loader bypassed.");
      _loaded = true;
      return;
    }
  }
}

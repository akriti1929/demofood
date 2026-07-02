import 'package:get/get.dart';

import '../controllers/map_setting_controller.dart';

class MapSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapSettingController>(
      () => MapSettingController(),
    );
  }
}

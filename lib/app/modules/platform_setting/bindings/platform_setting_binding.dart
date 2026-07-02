import 'package:get/get.dart';

import '../controllers/platform_setting_controller.dart';

class PlatformSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlatformSettingController>(
      () => PlatformSettingController(),
    );
  }
}

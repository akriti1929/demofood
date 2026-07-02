import 'package:get/get.dart';

import '../controllers/ai_setting_controller.dart';

class AiSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiSettingController>(
      () => AiSettingController(),
    );
  }
}

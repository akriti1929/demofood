import 'package:get/get.dart';

import '../controllers/admin_comission_setting_controller.dart';

class AdminComissionSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminComissionSettingController>(
      () => AdminComissionSettingController(),
    );
  }
}

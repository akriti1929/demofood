import 'package:get/get.dart';

import '../controllers/create_zone_controller.dart';

class CreateZoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateZoneController>(
      () => CreateZoneController(),
    );
  }
}

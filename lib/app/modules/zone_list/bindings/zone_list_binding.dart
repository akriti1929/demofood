import 'package:get/get.dart';

import '../controllers/zone_list_controller.dart';

class ZoneListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ZoneListController>(
      () => ZoneListController(),
    );
  }
}

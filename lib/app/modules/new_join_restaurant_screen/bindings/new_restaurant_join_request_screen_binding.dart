import 'package:get/get.dart';

import '../controllers/new_restaurant_join_request_controller.dart';

class NewRestaurantJoinRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewRestaurantJoinRequestController>(
      () => NewRestaurantJoinRequestController(),
    );
  }
}

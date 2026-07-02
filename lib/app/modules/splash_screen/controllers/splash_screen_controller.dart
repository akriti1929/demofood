import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  Future<void> onInit() async {
    await getData();
    Constant.getLanguageData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    bool isLogin = false;
    
    try {
      // Bypassing Firebase calls so the app doesn't hang forever
      await Future.delayed(const Duration(seconds: 1));
      isLogin = false;
      
      if (isLogin) {
        final admin = await FireStoreUtils.getAdmin();
        if (admin != null) {
          Constant.isDemoSet(admin);
        }
      }
    } catch (e) {
      // Ignore firebase errors since it's not configured
    }

    if (!isLogin && Get.currentRoute != Routes.LOGIN_PAGE) {
      Get.offAllNamed(Routes.LOGIN_PAGE);
    } else if (isLogin) {
      // Only navigate if currently in splash
      if (Get.currentRoute == Routes.SPLASH_SCREEN || Get.currentRoute.isEmpty) {
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
      }
    }

    isLoading.value = false;
  }
}

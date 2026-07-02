import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/zone_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:get/get.dart';

import '../../../constant/collection_name.dart';

class ZoneListController extends GetxController {
  RxBool isLoading = false.obs;
  RxString title = 'Zone'.tr.obs;

  RxList<ZoneModel> zoneList = <ZoneModel>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    try {
      zoneList.clear();
      final data = await FireStoreUtils.getZones();
      if (data!.isNotEmpty) {
        zoneList.addAll(data);
      }
    } catch (e) {
      ShowToastDialog.errorToast("Failed to load zones".tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeZone(ZoneModel zoneModel) async {
    isLoading.value = true;

    try {
      await FireStoreUtils.fireStore.collection(CollectionName.zones).doc(zoneModel.id).delete();

      ShowToastDialog.successToast("Zone deleted successfully!".tr);
    } catch (error) {
      ShowToastDialog.errorToast("Something went wrong while deleting zone".tr);
    }

    await getData();
    isLoading.value = false;
  }
}

import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/platform_fee_setting_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlatformSettingController extends GetxController {
  RxBool isLoading = false.obs;

  RxString title = "PlatForm Fee Settings".tr.obs;
  Rx<TextEditingController> platFormFeeController = TextEditingController().obs;
  Rx<Status> isActive = Status.active.obs;
  Rx<Status> packagingFeeActive = Status.active.obs;
  Rx<PlatFormFeeSettingModel> platFormFeeModel = PlatFormFeeSettingModel().obs;

  @override
  void onInit() {
    super.onInit();
    platFormFeeController.value.text = "0";
    getData();
  }

  Future<void> getData() async {
    isLoading.value = true;
    await FireStoreUtils.getPlatFormFeeSettings().then((value) {
      if (value != null) {
        platFormFeeModel.value = value;
        platFormFeeController.value.text = platFormFeeModel.value.platformFee!;
        isActive.value = platFormFeeModel.value.platformFeeActive == true ? Status.active : Status.inactive;
      }
    });
    isLoading.value = false;
  }

  Future<void> saveData() async {
    if (platFormFeeController.value.text.isEmpty || platFormFeeController.value.text == "") {
      return ShowToastDialog.errorToast("Please Add PlatForm Fee.".tr);
    } else {
      platFormFeeModel.value.platformFee = platFormFeeController.value.text;
      platFormFeeModel.value.platformFeeActive = isActive.value == Status.inactive ? false : true;
      platFormFeeModel.value.packagingFeeActive = packagingFeeActive.value == Status.inactive ? false : true;
      await FireStoreUtils.setPlatFormFeeSettings(platFormFeeModel.value);
      ShowToastDialog.successToast("Information Saved".tr);
    }
  }
}

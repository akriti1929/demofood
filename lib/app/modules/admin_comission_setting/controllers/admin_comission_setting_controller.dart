import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/admin_commission_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminComissionSettingController extends GetxController {
  RxBool isLoading = false.obs;
  RxString title = "Admin Commission Settings".tr.obs;
  List<String> vendorCommissionType = ["Fix", "Percentage"];
  RxString selectedVendorCommissionType = "Fix".obs;
  Rx<AdminCommission> adminCommissionModel = AdminCommission().obs;
  Rx<TextEditingController> vendorCommissionController = TextEditingController().obs;
  Rx<Status> isActiveVendor = Status.active.obs;

  Rx<TextEditingController> driverCommissionController = TextEditingController().obs;
  Rx<Status> isActiveDriver = Status.active.obs;
  RxString selectedDriverCommissionType = "Fix".obs;
  List<String> driverCommissionType = ["Fix", "Percentage"];

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    await getAdminCommissionData();
    isLoading(false);
  }

  Future<void> getAdminCommissionData() async {
    var result = await FireStoreUtils.getAdminCommission();

    if (result.isNotEmpty) {
      var vendor = result["vendor"]!;
      vendorCommissionController.value.text = vendor.value ?? "";
      selectedVendorCommissionType.value = vendor.isFix == true ? "Fix" : "Percentage";
      isActiveVendor.value = vendor.active == true ? Status.active : Status.inactive;
      var driver = result["driver"]!;
      driverCommissionController.value.text = driver.value ?? "";
      selectedDriverCommissionType.value = driver.isFix == true ? "Fix" : "Percentage";
      isActiveDriver.value = driver.active == true ? Status.active : Status.inactive;
    }
  }

  dynamic saveVendorData() async {
    if (selectedVendorCommissionType.isEmpty) {
      return ShowToastDialog.errorToast("Missing information. Please complete all required fields.".tr);
    } else if (vendorCommissionController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Please Add Vendor Commission".tr);
    }
    Constant.waitingLoader();
    try {
      adminCommissionModel.value.isFix = selectedVendorCommissionType.value == "Fix";
      adminCommissionModel.value.value = vendorCommissionController.value.text;
      adminCommissionModel.value.active = isActiveVendor.value == Status.active;

      Map<String, dynamic> vendorData = adminCommissionModel.value.toJson();

      await FireStoreUtils.setAdminCommission("vendor", vendorData);

      ShowToastDialog.successToast("Vendor commission saved.".tr);
      Get.back();
    } catch (e) {
      ShowToastDialog.errorToast("Something went wrong: $e");
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  dynamic saveDriverData() async {
    if (selectedDriverCommissionType.isEmpty) {
      return ShowToastDialog.errorToast("Missing information. Please complete all required fields.".tr);
    } else if (driverCommissionController.value.text.isEmpty) {
      return ShowToastDialog.errorToast("Please Add Driver Commission".tr);
    }
    Constant.waitingLoader();
    try {
      adminCommissionModel.value.isFix = selectedDriverCommissionType.value == "Fix";
      adminCommissionModel.value.value = driverCommissionController.value.text;
      adminCommissionModel.value.active = isActiveDriver.value == Status.active;

      Map<String, dynamic> driverData = adminCommissionModel.value.toJson();

      await FireStoreUtils.setAdminCommission("driver", driverData);

      ShowToastDialog.successToast("Driver commission saved.".tr);
      Get.back();
    } catch (e) {
      ShowToastDialog.errorToast("Something went wrong: $e");
    } finally {
      ShowToastDialog.closeLoader();
    }
  }
}

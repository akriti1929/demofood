// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/send_notification.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/push_notification_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNotificationController extends GetxController {
  RxString title = 'Push Notifications'.tr.obs;
  RxBool isLoading = false.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  Rx<PushNotificationModel> notificationModel = PushNotificationModel().obs;
  RxList<PushNotificationModel> notificationScreenList = <PushNotificationModel>[].obs;
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  List<String> userType = ["Customer", "Driver", "Vendor"];
  RxString selectedUserType = "Customer".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    notificationScreenList.clear();
    List<PushNotificationModel> data = await FireStoreUtils.getNotificationScreen();
    notificationScreenList.addAll(data);
    isLoading(false);
  }

  void setDefaultData() {
    titleController.value.text = "";
    descriptionController.value.text = "";
    selectedUserType.value = "Customer";
  }

  Future<void> addNotificationScreen() async {
    ShowToastDialog.showLoader("Please wait...".tr);
    notificationModel.value.id = Constant.getRandomString(20);
    notificationModel.value.title = titleController.value.text;
    notificationModel.value.description = descriptionController.value.text;
    notificationModel.value.type = selectedUserType.value == "Customer"
        ? "customer"
        : selectedUserType.value == "Driver"
            ? "driver"
            : "vendor";
    notificationModel.value.createdAt = Timestamp.now();

    await FireStoreUtils.addNotificationScreen(notificationModel.value).then((value) async {
      if (value == true) {
        Get.back();
        getData();
        ShowToastDialog.closeLoader();
        ShowToastDialog.successToast("Notification Send Successfully.".tr);
        SendNotification.sendTopicNotification(
          topic: selectedUserType.value == "Customer"
              ? "go4food-customer"
              : selectedUserType.value == "Driver"
                  ? "go4food-driver"
                  : "go4food-restaurant",
          title: titleController.value.text,
          body: descriptionController.value.text,
        );
        setDefaultData();
      }
    });
    isLoading.value = false;
  }

  Future<void> resendNotification(PushNotificationModel notification) async {
    ShowToastDialog.showLoader("Please wait...".tr);

    try {
      // ✅ Send notification again based on existing type
      SendNotification.sendTopicNotification(
        topic: notification.type == "customer"
            ? "go4food-customer"
            : notification.type == "driver"
                ? "go4food-driver"
                : "go4food-restaurant",
        title: notification.title ?? "",
        body: notification.description ?? "",
      );

      ShowToastDialog.closeLoader();
      ShowToastDialog.successToast("Notification Resent Successfully.".tr);
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.errorToast("Failed to resend notification.".tr);
    }
  }

  Future<void> removeNotification(PushNotificationModel notificationModel) async {
    ShowToastDialog.showLoader("Please wait...".tr);
    await FirebaseFirestore.instance.collection(CollectionName.notificationFromAdmin).doc(notificationModel.id).delete().then((value) {
      ShowToastDialog.closeLoader();
      getData();
      ShowToastDialog.successToast("Notification deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }
}

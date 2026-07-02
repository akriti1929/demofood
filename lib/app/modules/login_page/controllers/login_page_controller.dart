// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/admin_model.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  var isPasswordVisible = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  RxString email = "".obs;
  RxString password = "".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> checkAndLoginOrCreateAdmin() async {
    ShowToastDialog.showLoader("Please wait...".tr);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    String emailValue = emailController.text.trim();
    
    // Create a mock AdminModel to satisfy the app's data requirements
    AdminModel mockAdmin = AdminModel(
      id: "mock_admin_123",
      email: emailValue,
      name: "Admin User",
      image: "",
      contactNumber: "",
      isDemo: true,
    );
    
    Constant.isDemoSet(mockAdmin);
    Constant.isLogin = true;

    ShowToastDialog.successToast("Logged in successfully (Mock Mode)!".tr);
    ShowToastDialog.closeLoader();
    Get.offAllNamed(Routes.DASHBOARD_SCREEN);
  }

  Future<void> getData() async {
    await Constant.getCurrencyData();
    await Constant.getLanguageData();
  }
}

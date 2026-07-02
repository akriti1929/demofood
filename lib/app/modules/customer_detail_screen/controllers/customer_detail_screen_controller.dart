// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/send_notification.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/add_address_model.dart';
import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/models/wallet_transaction_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerDetailScreenController extends GetxController {
  RxString title = "User Detail".tr.obs;
  RxString transactionTitle = "Wallet Transaction".tr.obs;
  RxString addressTitle = "Address".tr.obs;
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<AddAddressModel> addressList = <AddAddressModel>[].obs;
  RxList<OrderModel> bookingList = <OrderModel>[].obs;
  RxInt totalOrders = 0.obs;
  Rx<TextEditingController> topUpAmountController = TextEditingController().obs;
  RxList<WalletTransactionModel> walletTransactionList = <WalletTransactionModel>[].obs;
  

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    String userId = Get.parameters['userId']!;

    try {
      UserModel? user = await FireStoreUtils.getUserByUserID(userId);
      if (user != null) {
        userModel.value = user;
        addressList.value = userModel.value.addAddresses ?? [];
        await getWalletTransaction();
      }
    } catch (e) {
      print("Error fetching user or addresses: $e");
    }

    await getOrders();
    totalOrders.value = await FireStoreUtils.countOrdersByCustomerId(userModel.value.id.toString());
  }

  Future<void> getOrders() async {
    isLoading.value = true;
    bookingList.value = await FireStoreUtils.getOrderByUserId(userModel.value.id);
    isLoading.value = false;
  }

  Future<void> getWalletTransaction() async {
    isLoading.value = true;
    await FireStoreUtils.getWalletTransactionByUserId(
      type: "user",
      userId: userModel.value.id.toString(),
    ).then((value) {
      walletTransactionList.value = value;
    }).catchError((error) {
      log("Error fetching wallet transactions: $error");
      ShowToastDialog.errorToast("Failed to fetch wallet transactions".tr);
    });
    isLoading.value = false;
  }

  Future<void> completeTopUp(String transactionId) async {
    Constant.loader();
    WalletTransactionModel walletTransactionModel = WalletTransactionModel(
      id: Constant.getUuid(),
      amount: topUpAmountController.value.text,
      createdDate: Timestamp.now(),
      userId: userModel.value.id,
      transactionId: transactionId,
      paymentType: "admin",
      note: "Wallet Top up by admin",
      type: "user",
      isCredit: true,
    );
    await FireStoreUtils.addWalletTransaction(walletTransactionModel).then((value) {
      if (value == true) {
        FireStoreUtils.updateUserWallet(
          amount: topUpAmountController.value.text,
          userId: userModel.value.id.toString(),
        ).then((value) async {
          if (value == true) {
            Get.back();
            ShowToastDialog.successToast("Top Up Successful".tr);
            userModel.value = (await FireStoreUtils.getUserByUserID(userModel.value.id.toString()))!;
            getWalletTransaction();
            Map<String, dynamic> payLoad = <String, dynamic>{"bookingId": ""};
            if (userModel.value.fcmToken != null && userModel.value.fcmToken!.isNotEmpty) {
              await SendNotification.sendOneNotification(
                  isNewOrder: false,
                  token: userModel.value.fcmToken.toString(),
                  title: "Wallet Top-Up Successful",
                  body: "${Constant.amountShow(amount: topUpAmountController.value.text)} has been successfully added to your wallet by the Admin.",
                  type: "wallet-topup",
                  payload: payLoad,
                  senderId: FireStoreUtils.getCurrentUid(),
                  driverId: userModel.value.id.toString(),
                  orderId: "");
            }
            topUpAmountController.value.clear();
          } else {
            log("Failed to update wallet");
          }
        });
      }
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
  }
}

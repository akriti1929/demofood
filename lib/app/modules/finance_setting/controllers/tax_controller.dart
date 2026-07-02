// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/tax_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TaxController extends GetxController {
  RxString title = "Taxes".tr.obs;
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  RxList<TaxModel> taxList = <TaxModel>[].obs;
  Rx<TaxModel> taxModel = TaxModel().obs;
  Rx<TextEditingController> taxNameController = TextEditingController().obs;
  Rx<TextEditingController> taxAmountController = TextEditingController().obs;

  Rx<bool> isActive = true.obs;
  RxString selectedCountry = "India".obs;

  List<String> taxType = ["Percentage", "Fix"];
  RxString selectedTaxType = "Percentage".obs;

  List<String> multipleTaxType = ["Restaurant", "Delivery", "Packaging"];
  RxString selectedMultipleTaxType = "Restaurant".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    taxList.clear();
    List<TaxModel>? data = await FireStoreUtils.getTax();
    taxList.addAll(data);
    isLoading.value = false;
  }

  void setDefaultData() {
    selectedCountry.value = "India";
    selectedTaxType.value = "Fix";
    selectedMultipleTaxType.value = "Restaurant";

    taxNameController.value.text = "";
    taxAmountController.value.text = "";

    isEditing.value = false;
    isLoading.value = false;
  }

  Future<void> addTax() async {
    isLoading.value = true;

    taxModel.value.id = Constant.getRandomString(20);
    taxModel.value.active = isActive.value;
    taxModel.value.country = selectedCountry.value;
    taxModel.value.isFix = selectedTaxType.value == "Fix";
    taxModel.value.name = taxNameController.value.text;
    taxModel.value.value = taxAmountController.value.text;
    taxModel.value.type = multipleTaxxType(selectedMultipleTaxType.value);

    await FireStoreUtils.addTax(taxModel.value);
    await getData();

    isLoading.value = false;
  }

  String multipleTaxxType(String type) {
    switch (type) {
      case "Restaurant":
        return "restaurant";
      case "Delivery":
        return "delivery";
      case "Packaging":
      default:
        return "packaging";
    }
  }

  Future<void> updateTax() async {
    taxModel.value.active = isActive.value;
    taxModel.value.country = selectedCountry.value;
    taxModel.value.isFix = selectedTaxType.value == "Fix";
    taxModel.value.name = taxNameController.value.text;
    taxModel.value.value = taxAmountController.value.text;
    taxModel.value.type = multipleTaxxType(selectedMultipleTaxType.value);

    await FireStoreUtils.updateTax(taxModel.value);
    await getData();
  }

  Future<void> removeTax(TaxModel taxModel) async {
    isLoading.value = true;

    await FirebaseFirestore.instance.collection(CollectionName.countryTax).doc(taxModel.id).delete().then((value) {
      ShowToastDialog.successToast("Tax removed successfully.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });

    isLoading.value = false;
  }

  String displayTaxType(String type) {
    switch (type) {
      case "restaurant":
        return "Restaurant";
      case "delivery":
        return "Delivery";
      case "packaging":
        return "Packaging";
      default:
        return "-";
    }
  }
}

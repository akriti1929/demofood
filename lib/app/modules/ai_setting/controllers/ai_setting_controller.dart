import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/aI_setting_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiSettingController extends GetxController {
  RxBool isLoading = false.obs;

  RxString title = "AI Settings".tr.obs;

  Rx<AISettingModel> aiSettingModel = AISettingModel().obs;
  Rx<TextEditingController> apiKeyController = TextEditingController().obs;
  Rx<TextEditingController> tokenController = TextEditingController().obs;
  Rx<TextEditingController> contentController = TextEditingController().obs;

  List<String> gptType = ['gpt-3.5-turbo', 'gpt-4', 'gpt-4o-mini'];
  RxString selectedGptType = "gpt-4".obs;
  Rx<Status> isActive = Status.active.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    await FireStoreUtils.getAiSettings().then((value) {
      if (value != null) {
        aiSettingModel.value = value;
        apiKeyController.value.text = aiSettingModel.value.apiKey!;
        tokenController.value.text = aiSettingModel.value.maxToken!;
        contentController.value.text = aiSettingModel.value.content!;
        selectedGptType.value = aiSettingModel.value.gptModel!;
        //isActive.value = aiSettingModel.value.active == true ? Status.active : Status.inactive;
      }
    });
    isLoading.value = false;
  }

  Future<void> saveData() async {
    String docId = Constant.getRandomString(20);
    if (selectedGptType.isEmpty) {
      return ShowToastDialog.errorToast("Please Select GPT Type.".tr);
    } else if (apiKeyController.value.text.isEmpty || apiKeyController.value.text == "") {
      return ShowToastDialog.errorToast("Please Add API Key.".tr);
    } else if (tokenController.value.text.isEmpty || tokenController.value.text == "") {
      return ShowToastDialog.errorToast("Please Add Token.".tr);
    } else if (contentController.value.text.isEmpty || contentController.value.text == "") {
      return ShowToastDialog.errorToast("Please Add Content.".tr);
    } else {
      aiSettingModel.value.id = docId;
      aiSettingModel.value.apiKey = apiKeyController.value.text;
      aiSettingModel.value.maxToken = tokenController.value.text;
      aiSettingModel.value.content = contentController.value.text;
      aiSettingModel.value.gptModel = selectedGptType.value;
      aiSettingModel.value.active = isActive.value == Status.inactive ? false : true;
      await FireStoreUtils.setAiSettings(aiSettingModel.value);
      ShowToastDialog.successToast("Information Saved".tr);
    }
  }
}

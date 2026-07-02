import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/map_setting_controller.dart';

class MapSettingView extends GetView<MapSettingController> {
  const MapSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<MapSettingController>(
      init: MapSettingController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerCustom(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                          spaceH(height: 2),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                  child: TextCustom(title: "Dashboard".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                              const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                              TextCustom(title: "Settings".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                              const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                              TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  spaceH(height: 20),
                  controller.isLoading.value
                      ? Padding(
                          padding: paddingEdgeInsets(),
                          child: Constant.loader(),
                        )
                      : ResponsiveWidget.isDesktop(context)
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                        maxLine: 1,
                                        title: "Google Map Key".tr,
                                        hintText: "Enter Google Map Key".tr,
                                        obscureText: Constant.isDemo ? true : false,
                                        prefix: const Icon(
                                          Icons.key,
                                          color: AppThemeData.lynch500,
                                        ),
                                        suffix: const SizedBox(),
                                        controller: controller.googleMapKeyController.value,
                                      ),
                                    ),
                                    spaceW(width: 24),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            title: "Type",
                                            maxLine: 1,
                                            fontSize: 14,
                                          ),
                                          spaceH(height: 10),
                                          Obx(
                                            () => DropdownButtonFormField(
                                              isExpanded: true,
                                              style: TextStyle(
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                              ),
                                              dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                              hint: TextCustom(title: "Select Distance Type".tr),
                                              onChanged: (String? mapType) {
                                                controller.selectMap.value = mapType ?? "Google Map";
                                              },
                                              value: controller.selectMap.value,
                                              items: controller.mapType.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: TextCustom(
                                                    title: value.tr,
                                                    fontFamily: FontFamily.regular,
                                                    fontSize: 16,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                                  ),
                                                );
                                              }).toList(),
                                              decoration: Constant.DefaultInputDecoration(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                spaceH(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomButtonWidget(
                                      padding: const EdgeInsets.symmetric(horizontal: 22),
                                      title: "Save".tr,
                                      onPress: () async {
                                        if (Constant.isDemo) {
                                          DialogBox.demoDialogBox();
                                        } else {
                                          controller.saveData();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Padding(
                              padding: paddingEdgeInsets(),
                              child: Column(
                                children: [
                                  CustomTextFormField(
                                    maxLine: 1,
                                    title: "Google Map Key".tr,
                                    hintText: "Enter Google Map Key".tr,
                                    obscureText: Constant.isDemo ? true : false,
                                    prefix: const Icon(
                                      Icons.key,
                                      color: AppThemeData.lynch500,
                                    ),
                                    suffix: const SizedBox(),
                                    controller: controller.googleMapKeyController.value,
                                  ),
                                  spaceH(height: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Type",
                                        maxLine: 1,
                                        fontSize: 14,
                                      ),
                                      spaceH(height: 10),
                                      Obx(
                                        () => DropdownButtonFormField(
                                          isExpanded: true,
                                          style: TextStyle(
                                            fontFamily: FontFamily.medium,
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                          ),
                                          dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                          hint: TextCustom(title: "Select Distance Type".tr),
                                          onChanged: (String? mapType) {
                                            controller.selectMap.value = mapType ?? "Google Map";
                                          },
                                          value: controller.selectMap.value,
                                          items: controller.mapType.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: TextCustom(
                                                title: value.tr,
                                                fontFamily: FontFamily.regular,
                                                fontSize: 16,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                              ),
                                            );
                                          }).toList(),
                                          decoration: Constant.DefaultInputDecoration(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  spaceH(height: 24),
                                  CustomButtonWidget(
                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                    title: "Save".tr,
                                    onPress: () async {
                                      if (Constant.isDemo) {
                                        DialogBox.demoDialogBox();
                                      } else {
                                        controller.saveData();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                ],
              ))
            ],
          ),
        );
      },
    );
  }
}

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/app/utils/screen_size.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/admin_comission_setting_controller.dart';

class AdminCommissionSettingView extends GetView<AdminComissionSettingController> {
  const AdminCommissionSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<AdminComissionSettingController>(
      init: AdminComissionSettingController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerCustom(
                  child: controller.isLoading.value
                      ? Padding(
                          padding: paddingEdgeInsets(),
                          child: Constant.loader(),
                        )
                      : ResponsiveWidget.isDesktop(context)
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: "Dashboard".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: "Settings".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ],
                                    ),
                                  ],
                                ),
                                spaceH(height: 20),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "VENDOR ADMIN COMMISSION".tr,
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          /// Commission Type
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                  maxLine: 1,
                                                  title: "Commission Type".tr,
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 14,
                                                ),
                                                spaceH(),
                                                Obx(() => DropdownButtonFormField(
                                                      isExpanded: true,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily.medium,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                                      ),
                                                      dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                      hint: TextCustom(title: "Select Tax Type".tr),
                                                      initialValue: controller.selectedVendorCommissionType.value,
                                                      items: controller.vendorCommissionType.map<DropdownMenuItem<String>>((String value) {
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
                                                      onChanged: (String? adminType) {
                                                        controller.selectedVendorCommissionType.value = adminType ?? "Fix";
                                                      },
                                                      decoration: Constant.DefaultInputDecoration(context),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                              hintText: "Enter Commission".tr,
                                              title: "Admin Commission".tr,
                                              controller: controller.vendorCommissionController.value,
                                            ),
                                          ),
                                        ],
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Obx(
                                                  () => Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Status".tr,
                                                        fontSize: 14,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      RadioGroup<Status>(
                                                        groupValue: controller.isActiveVendor.value,
                                                        onChanged: (value) {
                                                          controller.isActiveVendor.value = value!;
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Radio(
                                                                  value: Status.active,
                                                                  activeColor: AppThemeData.primary500,
                                                                ),
                                                                TextCustom(
                                                                  title: "Active".tr,
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ),
                                                            spaceW(),
                                                            Row(
                                                              children: [
                                                                const Radio(
                                                                  value: Status.inactive,
                                                                  activeColor: AppThemeData.primary500,
                                                                ),
                                                                TextCustom(
                                                                  title: "Inactive".tr,
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          spaceW(),
                                          Expanded(
                                            child: SizedBox(
                                              width: ScreenSize.width(100, context),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  CustomButtonWidget(
                                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                                    title: "Save".tr,
                                                    onPress: () async {
                                                      if (Constant.isDemo) {
                                                        DialogBox.demoDialogBox();
                                                      } else {
                                                        controller.saveVendorData();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "DRIVER ADMIN COMMISSION".tr,
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                  maxLine: 1,
                                                  title: "Commission Type".tr,
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 14,
                                                ),
                                                spaceH(),
                                                Obx(() => DropdownButtonFormField(
                                                      isExpanded: true,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily.medium,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                                      ),
                                                      dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                      hint: TextCustom(title: "Select Tax Type".tr),
                                                      initialValue: controller.selectedDriverCommissionType.value,
                                                      items: controller.driverCommissionType.map<DropdownMenuItem<String>>((String value) {
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
                                                      onChanged: (String? adminType) {
                                                        controller.selectedDriverCommissionType.value = adminType ?? "Fix";
                                                      },
                                                      decoration: Constant.DefaultInputDecoration(context),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                              hintText: "Enter Driver Commission".tr,
                                              title: "Admin Commission".tr,
                                              controller: controller.driverCommissionController.value,
                                            ),
                                          ),
                                        ],
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Obx(
                                                  () => Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Status".tr,
                                                        fontSize: 14,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      RadioGroup<Status>(
                                                        groupValue: controller.isActiveDriver.value,
                                                        onChanged: (value) {
                                                          controller.isActiveDriver.value = value!;
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Radio(
                                                                  value: Status.active,
                                                                  activeColor: AppThemeData.primary500,
                                                                ),
                                                                TextCustom(
                                                                  title: "Active".tr,
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ),
                                                            spaceW(),
                                                            Row(
                                                              children: [
                                                                const Radio(
                                                                  value: Status.inactive,
                                                                  activeColor: AppThemeData.primary500,
                                                                ),
                                                                TextCustom(
                                                                  title: "Inactive".tr,
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          spaceW(),
                                          Expanded(
                                            child: SizedBox(
                                              width: ScreenSize.width(100, context),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  CustomButtonWidget(
                                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                                    title: "Save".tr,
                                                    onPress: () async {
                                                      if (Constant.isDemo) {
                                                        DialogBox.demoDialogBox();
                                                      } else {
                                                        controller.saveDriverData();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: "Dashboard".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: "Settings".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ],
                                    ),
                                  ],
                                ),
                                spaceH(height: 20),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "ADMIN ADMIN COMMISSION".tr,
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            maxLine: 1,
                                            title: "Commission Type".tr,
                                            fontFamily: FontFamily.medium,
                                            fontSize: 14,
                                          ),
                                          spaceH(),
                                          Obx(() => DropdownButtonFormField(
                                                isExpanded: true,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                                ),
                                                dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                hint: TextCustom(title: "Select Tax Type".tr),
                                                initialValue: controller.selectedVendorCommissionType.value,
                                                items: controller.vendorCommissionType.map<DropdownMenuItem<String>>((String value) {
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
                                                onChanged: (String? adminType) {
                                                  controller.selectedVendorCommissionType.value = adminType ?? "Fix";
                                                },
                                                decoration: Constant.DefaultInputDecoration(context),
                                              )),
                                          spaceH(height: 16),
                                          CustomTextFormField(
                                              hintText: "Enter Commission Type".tr, title: "Admin Commission".tr, controller: controller.vendorCommissionController.value)
                                        ],
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Obx(
                                                  () => Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Status".tr,
                                                        fontSize: 14,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      RadioGroup<Status>(
                                                        groupValue: controller.isActiveVendor.value, // <-- FIXED
                                                        onChanged: (value) {
                                                          controller.isActiveVendor.value = value!;
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Radio(
                                                                  value: Status.active,
                                                                  activeColor: AppThemeData.primary500,
                                                                ),
                                                                TextCustom(
                                                                  title: "Active".tr,
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ),
                                                            spaceW(),
                                                            Row(
                                                              children: [
                                                                const Radio(
                                                                  value: Status.inactive,
                                                                  activeColor: AppThemeData.primary500,
                                                                ),
                                                                TextCustom(
                                                                  title: "Inactive".tr,
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          spaceW(),
                                          Expanded(
                                            child: SizedBox(
                                              width: ScreenSize.width(100, context),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  CustomButtonWidget(
                                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                                    title: "Save".tr,
                                                    onPress: () async {
                                                      if (Constant.isDemo) {
                                                        DialogBox.demoDialogBox();
                                                      } else {
                                                        controller.saveVendorData();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "DRIVER ADMIN COMMISSION".tr,
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            maxLine: 1,
                                            title: "Commission Type".tr,
                                            fontFamily: FontFamily.medium,
                                            fontSize: 14,
                                          ),
                                          spaceH(),
                                          Obx(() => DropdownButtonFormField(
                                                isExpanded: true,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                                ),
                                                dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                hint: TextCustom(title: "Select Tax Type".tr),
                                                initialValue: controller.selectedDriverCommissionType.value,
                                                items: controller.driverCommissionType.map<DropdownMenuItem<String>>((String value) {
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
                                                onChanged: (String? adminType) {
                                                  controller.selectedDriverCommissionType.value = adminType ?? "Fix";
                                                },
                                                decoration: Constant.DefaultInputDecoration(context),
                                              )),
                                          spaceH(height: 16),
                                          CustomTextFormField(
                                              hintText: "Enter Commission Type".tr, title: "Admin Commission".tr, controller: controller.driverCommissionController.value)
                                        ],
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Obx(
                                                  () => Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Status".tr,
                                                        fontSize: 14,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      RadioGroup<Status>(
                                                        groupValue: controller.isActiveDriver.value,
                                                        onChanged: (value) {
                                                          controller.isActiveDriver.value = value!;
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Radio(
                                                                  value: Status.active,
                                                                  activeColor: AppThemeData.primary500,
                                                                ),
                                                                TextCustom(
                                                                  title: "Active".tr,
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ),
                                                            spaceW(),
                                                            Row(
                                                              children: [
                                                                const Radio(
                                                                  value: Status.inactive,
                                                                  activeColor: AppThemeData.primary500,
                                                                ),
                                                                TextCustom(
                                                                  title: "Inactive".tr,
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          spaceW(),
                                          Expanded(
                                            child: SizedBox(
                                              width: ScreenSize.width(100, context),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  CustomButtonWidget(
                                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                                    title: "Save".tr,
                                                    onPress: () async {
                                                      if (Constant.isDemo) {
                                                        DialogBox.demoDialogBox();
                                                      } else {
                                                        controller.saveDriverData();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
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

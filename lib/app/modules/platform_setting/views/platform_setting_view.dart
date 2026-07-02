// ignore_for_file: unused_local_variable, deprecated_member_use

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
import '../controllers/platform_setting_controller.dart';

class PlatformSettingView extends GetView<PlatformSettingController> {
  const PlatformSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<PlatformSettingController>(
      init: PlatformSettingController(),
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
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                              title: "PlatForm Fee".tr,
                                              hintText: "Enter PlatForm Fee".tr,
                                              controller: controller.platFormFeeController.value,
                                            ),
                                          ),
                                          spaceW(width: 20),
                                          Expanded(
                                            child: Obx(
                                              () => Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Status".tr,
                                                        fontSize: 14,
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Radio(
                                                                value: Status.active,
                                                                groupValue: controller.isActive.value,
                                                                onChanged: (value) {
                                                                  controller.isActive.value = value ?? Status.active;
                                                                },
                                                                activeColor: AppThemeData.primary500,
                                                              ),
                                                              TextCustom(
                                                                title: "Active".tr,
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              )
                                                            ],
                                                          ),
                                                          spaceW(),
                                                          Row(
                                                            children: [
                                                              Radio(
                                                                value: Status.inactive,
                                                                groupValue: controller.isActive.value,
                                                                onChanged: (value) {
                                                                  controller.isActive.value = value ?? Status.inactive;
                                                                },
                                                                activeColor: AppThemeData.primary500,
                                                              ),
                                                              TextCustom(
                                                                title: "Inactive".tr,
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      spaceH(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Obx(
                                              () => Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Packaging Fee".tr,
                                                        fontSize: 14,
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Radio(
                                                                value: Status.active,
                                                                groupValue: controller.packagingFeeActive.value,
                                                                onChanged: (value) {
                                                                  controller.packagingFeeActive.value = value ?? Status.active;
                                                                },
                                                                activeColor: AppThemeData.primary500,
                                                              ),
                                                              TextCustom(
                                                                title: "Active".tr,
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              )
                                                            ],
                                                          ),
                                                          spaceW(),
                                                          Row(
                                                            children: [
                                                              Radio(
                                                                value: Status.inactive,
                                                                groupValue: controller.packagingFeeActive.value,
                                                                onChanged: (value) {
                                                                  controller.packagingFeeActive.value = value ?? Status.inactive;
                                                                },
                                                                activeColor: AppThemeData.primary500,
                                                              ),
                                                              TextCustom(
                                                                title: "Inactive".tr,
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          spaceW(width: 20),
                                          Expanded(child: SizedBox())
                                        ],
                                      ),
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
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFormField(
                                        title: "PlatForm Fee".tr,
                                        hintText: "Enter PlatForm Fee".tr,
                                        controller: controller.platFormFeeController.value,
                                      ),
                                      spaceH(height: 16),
                                      Obx(
                                        () => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                  title: "Status".tr,
                                                  fontSize: 14,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: Status.active,
                                                          groupValue: controller.isActive.value,
                                                          onChanged: (value) {
                                                            controller.isActive.value = value ?? Status.active;
                                                          },
                                                          activeColor: AppThemeData.primary500,
                                                        ),
                                                        TextCustom(
                                                          title: "Active".tr,
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                        )
                                                      ],
                                                    ),
                                                    spaceW(),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: Status.inactive,
                                                          groupValue: controller.isActive.value,
                                                          onChanged: (value) {
                                                            controller.isActive.value = value ?? Status.inactive;
                                                          },
                                                          activeColor: AppThemeData.primary500,
                                                        ),
                                                        TextCustom(
                                                          title: "Inactive".tr,
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Obx(
                                              () => Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Packaging Fee".tr,
                                                        fontSize: 14,
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Radio(
                                                                value: Status.active,
                                                                groupValue: controller.packagingFeeActive.value,
                                                                onChanged: (value) {
                                                                  controller.packagingFeeActive.value = value ?? Status.active;
                                                                },
                                                                activeColor: AppThemeData.primary500,
                                                              ),
                                                              TextCustom(
                                                                title: "Active".tr,
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              )
                                                            ],
                                                          ),
                                                          spaceW(),
                                                          Row(
                                                            children: [
                                                              Radio(
                                                                value: Status.inactive,
                                                                groupValue: controller.packagingFeeActive.value,
                                                                onChanged: (value) {
                                                                  controller.packagingFeeActive.value = value ?? Status.inactive;
                                                                },
                                                                activeColor: AppThemeData.primary500,
                                                              ),
                                                              TextCustom(
                                                                title: "Inactive".tr,
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          spaceW(width: 20),
                                          Expanded(child: SizedBox())
                                        ],
                                      ),
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
                                  ),
                                )
                              ],
                            ))
            ],
          ),
        );
      },
    );
  }
}

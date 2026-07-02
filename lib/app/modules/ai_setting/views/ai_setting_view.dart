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
import '../controllers/ai_setting_controller.dart';

class AiSettingView extends GetView<AiSettingController> {
  const AiSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<AiSettingController>(
      init: AiSettingController(),
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
                                            title: "Api Key".tr,
                                            hintText: "Enter Api Key".tr,
                                            controller: controller.apiKeyController.value,
                                            obscureText: Constant.isDemo ? true : false,
                                          )),
                                          spaceW(width: 20),
                                          Expanded(child: CustomTextFormField(title: "Token".tr, hintText: "Enter Max Token".tr, controller: controller.tokenController.value)),
                                        ],
                                      ),
                                      spaceH(height: 20),
                                      Row(
                                        children: [
                                          // Expanded(
                                          //     child: CustomTextFormField(
                                          //   title: "Content".tr,
                                          //   hintText: "Enter Your Content".tr,
                                          //   controller: controller.contentController.value,
                                          //   obscureText: Constant.isDemo ? true : false,
                                          // )),
                                          // spaceW(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                  maxLine: 1,
                                                  title: "GPT Model".tr,
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 14,
                                                ),
                                                spaceH(),
                                                Obx(
                                                  () => DropdownButtonFormField(
                                                    isExpanded: true,
                                                    dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.medium,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                                    ),
                                                    hint: TextCustom(title: "Select GPT Type".tr),
                                                    onChanged: (String? gptType) {
                                                      controller.selectedGptType.value = gptType ?? "gpt-4";
                                                    },
                                                    initialValue: controller.selectedGptType.value,
                                                    items: controller.gptType.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem(
                                                        value: value,
                                                        child: TextCustom(
                                                          title: value,
                                                          fontFamily: FontFamily.medium,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                                        ),
                                                      );
                                                    }).toList(),
                                                    decoration: Constant.DefaultInputDecoration(context),
                                                  ),
                                                ),
                                              ],
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
                                        title: "Api Key".tr,
                                        hintText: "Enter Api Key".tr,
                                        controller: controller.apiKeyController.value,
                                        obscureText: Constant.isDemo ? true : false,
                                      ),
                                      spaceH(height: 16),
                                      CustomTextFormField(title: "Token".tr, hintText: "Enter Max Token".tr, controller: controller.tokenController.value),
                                      spaceH(height: 16),
                                      // CustomTextFormField(
                                      //   title: "Content".tr,
                                      //   hintText: "Enter Your Content".tr,
                                      //   controller: controller.contentController.value,
                                      //   obscureText: Constant.isDemo ? true : false,
                                      // ),
                                      // spaceH(height: 16),
                                      TextCustom(
                                        maxLine: 1,
                                        title: "GPT Type".tr,
                                        fontFamily: FontFamily.medium,
                                        fontSize: 14,
                                      ),
                                      spaceH(),
                                      Obx(
                                        () => DropdownButtonFormField(
                                          isExpanded: true,
                                          dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                          style: TextStyle(
                                            fontFamily: FontFamily.medium,
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                          ),
                                          hint: TextCustom(title: "Select GPT Type".tr),
                                          onChanged: (String? gptType) {
                                            controller.selectedGptType.value = gptType ?? "gpt-4";
                                          },
                                          initialValue: controller.selectedGptType.value,
                                          items: controller.gptType.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: TextCustom(
                                                title: value,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                              ),
                                            );
                                          }).toList(),
                                          decoration: Constant.DefaultInputDecoration(context),
                                        ),
                                      ),
                                      spaceH(),
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

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
import '../controllers/smtp_settings_controller.dart';

class SmtpSettingsView extends GetView<SmtpSettingsController> {
  const SmtpSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SmtpSettingsController>(
      init: SmtpSettingsController(),
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
                                              child: CustomTextFormField(title: "SMTP Host".tr, hintText: "Enter SMTP Host".tr, controller: controller.smtpHostController.value)),
                                          spaceW(width: 20),
                                          Expanded(
                                              child: CustomTextFormField(title: "SMTP Port".tr, hintText: "Enter SMTP Port".tr, controller: controller.smtpPortController.value)),
                                        ],
                                      ),
                                      spaceH(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: CustomTextFormField(
                                            title: "User Name".tr,
                                            hintText: "Enter User Name".tr,
                                            controller: controller.userNameController.value,
                                            obscureText: Constant.isDemo ? true : false,
                                          )),
                                          spaceW(width: 20),
                                          Expanded(
                                              child: CustomTextFormField(
                                            title: "Password".tr,
                                            hintText: "Enter Password".tr,
                                            controller: controller.passwordController.value,
                                            obscureText: Constant.isDemo ? true : false,
                                          )),
                                        ],
                                      ),
                                      spaceH(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                  maxLine: 1,
                                                  title: "Encryption Type".tr,
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
                                                    hint: TextCustom(title: "Select EncryptionType Type".tr),
                                                    onChanged: (String? encryptionType) {
                                                      controller.selectedEncryptionType.value = encryptionType ?? "SSL";
                                                    },
                                                    initialValue: controller.selectedEncryptionType.value,
                                                    items: controller.encryptionType.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem(
                                                        value: value,
                                                        child: TextCustom(
                                                          title: value.tr,
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
                                          Expanded(child: SizedBox())
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
                                      CustomTextFormField(title: "SMTP Host".tr, hintText: "Enter SMTP Host".tr, controller: controller.smtpHostController.value),
                                      spaceH(height: 16),
                                      CustomTextFormField(title: "SMTP Port".tr, hintText: "Enter SMTP Port".tr, controller: controller.smtpPortController.value),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                        title: "User Name".tr,
                                        hintText: "Enter User Name".tr,
                                        controller: controller.userNameController.value,
                                        obscureText: Constant.isDemo ? true : false,
                                      ),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                        title: "Password".tr,
                                        hintText: "Enter Password".tr,
                                        controller: controller.passwordController.value,
                                        obscureText: Constant.isDemo ? true : false,
                                      ),
                                      spaceH(height: 16),
                                      TextCustom(
                                        maxLine: 1,
                                        title: "Encryption Type".tr,
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
                                          hint: TextCustom(title: "Select EncryptionType Type".tr),
                                          onChanged: (String? encryptionType) {
                                            controller.selectedEncryptionType.value = encryptionType ?? "SSL";
                                          },
                                          initialValue: controller.selectedEncryptionType.value,
                                          items: controller.encryptionType.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: TextCustom(
                                                title: value.tr,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                              ),
                                            );
                                          }).toList(),
                                          decoration: Constant.DefaultInputDecoration(context),
                                        ),
                                      ),
                                      spaceH(height: 16),
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

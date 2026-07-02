// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/push_notification_model.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/add_notification_controller.dart';

class AddNotificationView extends GetView<AddNotificationController> {
  const AddNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddNotificationController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              leadingWidth: 200,
              leading: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      if (!ResponsiveWidget.isDesktop(context)) {
                        Scaffold.of(context).openDrawer();
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: !ResponsiveWidget.isDesktop(context)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.menu,
                                size: 30,
                                color: themeChange.isDarkTheme() ? AppThemeData.primary500 : AppThemeData.primary500,
                              ),
                            )
                          : SizedBox(
                              height: 45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/logo.png",
                                    height: 34,
                                  ),
                                  spaceW(),
                                  TextCustom(
                                    title: '${Constant.appName}',
                                    color: AppThemeData.primary500,
                                    fontSize: 25,
                                    fontFamily: FontFamily.titleBold,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    if (themeChange.darkTheme == 1) {
                      themeChange.darkTheme = 0;
                    } else if (themeChange.darkTheme == 0) {
                      themeChange.darkTheme = 1;
                    } else if (themeChange.darkTheme == 2) {
                      themeChange.darkTheme = 0;
                    } else {
                      themeChange.darkTheme = 2;
                    }
                  },
                  child: themeChange.isDarkTheme()
                      ? SvgPicture.asset(
                          "assets/icons/ic_sun.svg",
                          color: AppThemeData.lynch100,
                          height: 20,
                          width: 20,
                        )
                      : SvgPicture.asset(
                          "assets/icons/ic_moon.svg",
                          color: AppThemeData.lynch900,
                          height: 20,
                          width: 20,
                        ),
                ),
                spaceW(),
                const LanguagePopUp(),
                spaceW(),
                ProfilePopUp()
              ],
            ),
            drawer: Drawer(
              width: 270,
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              child: const MenuWidget(),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
                Expanded(
                  child: Padding(
                      padding: paddingEdgeInsets(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          ContainerCustom(
                            child: Column(children: [
                              ResponsiveWidget.isDesktop(context)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                          spaceH(height: 2),
                                          Row(children: [
                                            InkWell(
                                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                child: TextCustom(title: "Dashboard".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                            TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                          ])
                                        ]),
                                        spaceH(),
                                        Row(
                                          children: [
                                            // NumberOfRowsDropDown(
                                            //   controller: controller,
                                            // ),
                                            CustomButtonWidget(
                                                title: "+ Add Notification".tr,
                                                onPress: () {
                                                  controller.setDefaultData();
                                                  showDialog(context: context, builder: (context) => const AddNotificationDialog());
                                                })
                                          ],
                                        )
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                          spaceH(height: 2),
                                          Row(children: [
                                            InkWell(
                                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                child: TextCustom(title: "Dashboard".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                            TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                          ])
                                        ]),
                                        spaceH(),
                                        Row(
                                          children: [
                                            // NumberOfRowsDropDown(
                                            //   controller: controller,
                                            // ),
                                            CustomButtonWidget(
                                                title: "+ Add Notification".tr,
                                                onPress: () {
                                                  controller.setDefaultData();
                                                  showDialog(context: context, builder: (context) => const AddNotificationDialog());
                                                })
                                          ],
                                        )
                                      ],
                                    ),
                              spaceH(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: controller.isLoading.value
                                      ? Padding(
                                          padding: paddingEdgeInsets(),
                                          child: Constant.loader(),
                                        )
                                      : controller.notificationScreenList.isEmpty
                                          ? TextCustom(title: "No Data available".tr)
                                          : DataTable(
                                              horizontalMargin: 20,
                                              columnSpacing: 30,
                                              dataRowMaxHeight: 65,
                                              headingRowHeight: 65,
                                              border: TableBorder.all(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                                              columns: [
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Title".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.14),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Description".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.20),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Type".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.08),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 90 : MediaQuery.of(context).size.width * 0.08),
                                              ],
                                              rows: controller.notificationScreenList
                                                  .map((notification) => DataRow(cells: [
                                                        DataCell(TextCustom(title: notification.title ?? "N/A".tr)),
                                                        DataCell(TextCustom(
                                                          title: notification.description ?? "N/A".tr,
                                                          maxLine: 2,
                                                        )),
                                                        DataCell(TextCustom(
                                                          title: notification.type == "customer"
                                                              ? "Customer".tr
                                                              : notification.type == "driver"
                                                                  ? "Driver".tr
                                                                  : "Vendor".tr,
                                                        )),
                                                        DataCell(
                                                          Container(
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () async {
                                                                    if (Constant.isDemo) {
                                                                      DialogBox.demoDialogBox();
                                                                    } else {
                                                                      bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                      if (confirmDelete) {
                                                                        await controller.removeNotification(notification);
                                                                      }
                                                                    }
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    "assets/icons/ic_delete.svg",
                                                                    height: 16,
                                                                    width: 16,
                                                                  ),
                                                                ),
                                                                spaceW(),
                                                                CustomButtonWidget(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                                                    height: 35,
                                                                    width: 90,
                                                                    title: "Resend".tr,
                                                                    onPress: () {
                                                                      controller.resendNotification(notification);
                                                                    })
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]))
                                                  .toList()),
                                ),
                              ),
                              spaceH(),
                            ]),
                          )
                        ]),
                      )),
                ),
              ],
            ),
          );
        });
  }
}

class AddNotificationDialog extends StatelessWidget {
  final PushNotificationModel? notificationScreenModel;

  const AddNotificationDialog({super.key, this.notificationScreenModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddNotificationController(),
        builder: (controller) {
          return CustomDialog(
            controller: controller,
            title: controller.title.value,
            widgetList: [
              Row(
                children: [
                  Expanded(child: CustomTextFormField(hintText: "Enter Title".tr, title: "Title".tr, controller: controller.titleController.value)),
                  spaceW(width: 12),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: "User Type".tr,
                        fontSize: 14,
                      ),
                      spaceH(height: 10),
                      Obx(
                        () => DropdownButtonFormField(
                          isExpanded: true,
                          dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                          ),
                          hint: TextCustom(
                              title: "Select User Type".tr,
                              fontSize: 14,
                              fontFamily: FontFamily.regular,
                              color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400),
                          onChanged: (String? userType) {
                            controller.selectedUserType.value = userType ?? "Customer";
                          },
                          value: controller.selectedUserType.value,
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          items: controller.userType.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: FontFamily.regular,
                                  fontSize: 14,
                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: Constant.DefaultInputDecoration(context),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              spaceH(height: 20),
              CustomTextFormField(
                hintText: "Enter Description".tr,
                title: "Description".tr,
                controller: controller.descriptionController.value,
                maxLine: 2,
              ),
            ],
            bottomWidgetList: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButtonWidget(
                    title: "Close".tr,
                    buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch500,
                    onPress: () {
                      controller.setDefaultData();
                      Navigator.pop(context);
                    },
                  ),
                  spaceW(),
                  CustomButtonWidget(
                    title: "Send".tr,
                    onPress: () {
                      if (Constant.isDemo) {
                        DialogBox.demoDialogBox();
                      } else {
                        if (controller.titleController.value.text.isNotEmpty && controller.descriptionController.value.text.isNotEmpty) {
                          controller.addNotificationScreen();
                        } else {
                          ShowToastDialog.errorToast("All fields are required.".tr);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}

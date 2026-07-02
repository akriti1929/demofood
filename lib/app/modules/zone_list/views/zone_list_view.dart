import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/zone_list_controller.dart';

class ZoneListView extends GetView<ZoneListController> {
  const ZoneListView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: ZoneListController(),
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
                          colorFilter: const ColorFilter.mode(
                            AppThemeData.lynch100,
                            BlendMode.srcIn,
                          ),
                          height: 20,
                          width: 20,
                        )
                      : SvgPicture.asset(
                          "assets/icons/ic_moon.svg",
                          colorFilter: const ColorFilter.mode(
                            AppThemeData.lynch900,
                            BlendMode.srcIn,
                          ),
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
                    child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: paddingEdgeInsets(),
                        child: ContainerCustom(
                          child: Column(
                            children: [
                              Row(
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
                                  CustomButtonWidget(
                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                    title: "+ Add Zone".tr,
                                    onPress: () {
                                      Get.toNamed(Routes.CREATE_ZONE)!.then((value) {
                                        if (value == true) {
                                          controller.getData();
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              spaceH(height: 20),
                              controller.isLoading.value
                                  ? Padding(
                                      padding: paddingEdgeInsets(),
                                      child: Constant.loader(),
                                    )
                                  : controller.zoneList.isEmpty
                                      ? TextCustom(title: "No Data available".tr)
                                      : SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: DataTable(
                                                  horizontalMargin: 20,
                                                  columnSpacing: 30,
                                                  dataRowMaxHeight: 65,
                                                  headingRowHeight: 65,
                                                  border: TableBorder.all(
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  headingRowColor:
                                                      WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                                                  columns: [
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Id".tr, width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.14),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.1),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Created At".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.05),
                                                    CommonUI.dataColumnWidget(context,
                                                        columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 70 : MediaQuery.of(context).size.width * 0.08),
                                                  ],
                                                  rows: controller.zoneList
                                                      .map((zoneList) => DataRow(cells: [
                                                            DataCell(
                                                              Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                  child: TextCustom(title: "#${zoneList.id!.substring(0, 8)}")),
                                                            ),
                                                            DataCell(
                                                              Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child: TextCustom(title: "${zoneList.name}")),
                                                            ),
                                                            DataCell(
                                                              Transform.scale(
                                                                scale: 0.8,
                                                                child: CupertinoSwitch(
                                                                  activeTrackColor: AppThemeData.primary500,
                                                                  value: zoneList.status!,
                                                                  onChanged: (value) async {
                                                                    if (Constant.isDemo) {
                                                                      DialogBox.demoDialogBox();
                                                                    } else {
                                                                      zoneList.status = value;
                                                                      await FireStoreUtils.updateZone(zoneList);
                                                                      controller.getData();
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                  child: TextCustom(title: Constant.timestampToDateTime(zoneList.createdAt!))),
                                                            ),
                                                            DataCell(Row(
                                                              children: [
                                                                InkWell(
                                                                    onTap: () async {
                                                                      final result = await Get.toNamed('${Routes.CREATE_ZONE}/${zoneList.id}');
                                                                      if (result == true) {
                                                                        controller.getData();
                                                                      }
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      "assets/icons/ic_edit.svg",
                                                                      colorFilter: ColorFilter.mode(
                                                                        AppThemeData.lynch400,
                                                                        BlendMode.srcIn,
                                                                      ),
                                                                      height: 16,
                                                                      width: 16,
                                                                    )),
                                                                spaceW(width: 16),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    if (Constant.isDemo) {
                                                                      DialogBox.demoDialogBox();
                                                                    } else {
                                                                      bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                      if (confirmDelete) {
                                                                        await controller.removeZone(zoneList);
                                                                        controller.getData();
                                                                      }
                                                                    }
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    "assets/icons/ic_delete.svg",
                                                                    colorFilter: ColorFilter.mode(
                                                                      AppThemeData.red500,
                                                                      BlendMode.srcIn,
                                                                    ),
                                                                    height: 16,
                                                                    width: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                          ]))
                                                      .toList())))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ));
      },
    );
  }
}

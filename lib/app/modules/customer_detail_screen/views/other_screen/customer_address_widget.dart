import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/modules/customer_detail_screen/controllers/customer_detail_screen_controller.dart';
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
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../routes/app_pages.dart';

class CustomerAddressWidget extends StatelessWidget {
  const CustomerAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CustomerDetailScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: WidgetStateColor.transparent,
            body: SingleChildScrollView(
              child: ContainerCustom(
                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                TextCustom(title: controller.addressTitle.value, fontSize: 20, fontFamily: FontFamily.bold),
                                spaceH(height: 2),
                                Row(children: [
                                  InkWell(
                                      onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                      child: TextCustom(title: "Dashboard".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                  TextCustom(title: ' ${controller.addressTitle.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                ])
                              ]),
                            ],
                          ),
                          spaceH(height: 16),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              spaceH(height: 16),
                              Obx(
                                () => controller.addressList.isEmpty
                                    ? Center(
                                        child: TextCustom(title: "No Address Found".tr),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: DataTable(
                                              horizontalMargin: 20,
                                              columnSpacing: 30,
                                              dataRowMaxHeight: 70,
                                              headingRowHeight: 65,
                                              border: TableBorder.all(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              headingRowColor: WidgetStateColor.resolveWith(
                                                (states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                              ),
                                              columns: [
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Address".tr, width: ResponsiveWidget.isMobile(context) ? 200 : MediaQuery.of(context).size.width * 0.20),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Address As".tr, width: 120),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Landmark".tr, width: 150),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Locality".tr, width: 150),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Default".tr, width: 100),
                                              ],
                                              rows: controller.addressList.asMap().entries.map((entry) {
                                                int index = entry.key;
                                                var addr = entry.value;

                                                return DataRow(
                                                  cells: [
                                                    DataCell(TextCustom(
                                                      title: addr.getFullAddress(),
                                                    )),
                                                    DataCell(TextCustom(
                                                      title: addr.addressAs ?? "-",
                                                    )),
                                                    DataCell(TextCustom(
                                                      title: addr.landmark ?? "-",
                                                    )),
                                                    DataCell(TextCustom(
                                                      title: addr.locality ?? "-",
                                                    )),
                                                    DataCell(
                                                      Transform.scale(
                                                        scale: 0.8,
                                                        child: CupertinoSwitch(
                                                            activeTrackColor: AppThemeData.primary500,
                                                            value: addr.isDefault ?? false,
                                                            onChanged: (value) async {
                                                              if (Constant.isDemo) {
                                                                DialogBox.demoDialogBox();
                                                                return;
                                                              }
                                                              if (addr.isDefault == true && value == false) {
                                                                ShowToastDialog.errorToast("Default address cannot be removed.");
                                                                return;
                                                              }
                                                              if (value == true) {
                                                                for (var item in controller.addressList) {
                                                                  item.isDefault = false;
                                                                }
                                                                controller.addressList[index].isDefault = true;
                                                                controller.userModel.value.addAddresses = controller.addressList;

                                                                await FireStoreUtils.updateUsers(controller.userModel.value);
                                                                controller.addressList.refresh();
                                                              }
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

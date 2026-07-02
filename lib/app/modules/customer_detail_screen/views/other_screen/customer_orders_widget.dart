// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/models/product_model.dart';
import 'package:admin_panel/app/modules/customer_detail_screen/controllers/customer_detail_screen_controller.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../../widget/common_ui.dart';
import '../../../../../widget/container_custom.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/dialog_box.dart';
import '../../../../constant/constants.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/fire_store_utils.dart';

class CustomerOrdersWidget extends StatelessWidget {
  const CustomerOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CustomerDetailScreenController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: WidgetStateColor.transparent,
              body: ResponsiveWidget(
                  mobile: controller.isLoading.value
                      ? Constant.loader()
                      : ContainerCustom(
                          color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller.bookingList.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 30),
                                          child: TextCustom(
                                            title: "No Orders Found".tr,
                                            fontSize: 16,
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            title: "Order History".tr,
                                            fontSize: 18,
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                          ),
                                          spaceH(),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: DataTable(
                                                horizontalMargin: 20,
                                                columnSpacing: 30,
                                                dataRowMaxHeight: 65,
                                                headingRowHeight: 65,
                                                border: TableBorder.all(
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                headingRowColor:
                                                    WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                columns: [
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: 100),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Price".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.04),
                                                ],
                                                rows: controller.bookingList
                                                    .map((bookingModel) => DataRow(cells: [
                                                          DataCell(
                                                            TextCustom(
                                                              title: bookingModel.id!.isEmpty ? "N/A".tr : "#${bookingModel.id!.substring(0, 4)}",
                                                            ),
                                                          ),
                                                          DataCell(
                                                            SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: List.generate(
                                                                  bookingModel.items!.length,
                                                                  (index) {
                                                                    return FutureBuilder<ProductModel?>(
                                                                      future: FireStoreUtils.getProductByProductId(
                                                                        bookingModel.items![index].productId.toString(),
                                                                      ),
                                                                      builder: (context, snapshot) {
                                                                        if (!snapshot.hasData) {
                                                                          return Container();
                                                                        }
                                                                        ProductModel? product = snapshot.data ?? ProductModel();
                                                                        return Padding(
                                                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                          child: Row(
                                                                            children: [
                                                                              NetworkImageWidget(
                                                                                imageUrl: product.productImage.toString(),
                                                                                height: 24,
                                                                                width: 24,
                                                                              ),
                                                                              spaceW(width: 12),
                                                                              TextCustom(
                                                                                title: product.productName.toString(),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            TextCustom(
                                                              title: Constant.timestampToDate(bookingModel.createdAt!),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            TextCustom(
                                                              title: Constant.amountShow(amount: bookingModel.totalAmount.toString()),
                                                            ),
                                                          ),
                                                          DataCell(Constant.bookingStatusText(context, bookingModel.orderStatus)),
                                                          DataCell(
                                                            InkWell(
                                                              onTap: () async {
                                                                Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${bookingModel.id}");
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_eye.svg",
                                                                color: AppThemeData.lynch400,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                          )
                                                        ]))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                  tablet: controller.isLoading.value
                      ? Constant.loader()
                      : ContainerCustom(
                          color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller.bookingList.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 30),
                                        child: TextCustom(
                                          title: "No Orders Found".tr,
                                          fontSize: 16,
                                          fontFamily: FontFamily.regular,
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(
                                          title: "Order History".tr,
                                          fontSize: 18,
                                          fontFamily: FontFamily.regular,
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                        ),
                                        spaceH(),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: DataTable(
                                              horizontalMargin: 20,
                                              columnSpacing: 30,
                                              dataRowMaxHeight: 65,
                                              headingRowHeight: 65,
                                              border: TableBorder.all(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                              columns: [
                                                CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: 100),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Price".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.04),
                                              ],
                                              rows: controller.bookingList
                                                  .map((bookingModel) => DataRow(cells: [
                                                        DataCell(
                                                          TextCustom(
                                                            title: bookingModel.id!.isEmpty ? "N/A".tr : "#${bookingModel.id!.substring(0, 4)}",
                                                          ),
                                                        ),
                                                        DataCell(
                                                          SingleChildScrollView(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: List.generate(
                                                                bookingModel.items!.length,
                                                                (index) {
                                                                  return FutureBuilder<ProductModel?>(
                                                                    future: FireStoreUtils.getProductByProductId(
                                                                      bookingModel.items![index].productId.toString(),
                                                                    ),
                                                                    builder: (context, snapshot) {
                                                                      if (!snapshot.hasData) {
                                                                        return Container();
                                                                      }
                                                                      ProductModel? product = snapshot.data ?? ProductModel();
                                                                      return Padding(
                                                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                        child: Row(
                                                                          children: [
                                                                            NetworkImageWidget(
                                                                              imageUrl: product.productImage.toString(),
                                                                              height: 24,
                                                                              width: 24,
                                                                            ),
                                                                            spaceW(width: 12),
                                                                            TextCustom(
                                                                              title: product.productName.toString(),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          TextCustom(
                                                            title: Constant.timestampToDate(bookingModel.createdAt!),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          TextCustom(
                                                            title: Constant.amountShow(amount: bookingModel.totalAmount.toString()),
                                                          ),
                                                        ),
                                                        DataCell(Constant.bookingStatusText(context, bookingModel.orderStatus)),
                                                        DataCell(
                                                          InkWell(
                                                            onTap: () async {
                                                              Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${bookingModel.id}");
                                                            },
                                                            child: SvgPicture.asset(
                                                              "assets/icons/ic_eye.svg",
                                                              color: AppThemeData.lynch400,
                                                              height: 16,
                                                              width: 16,
                                                            ),
                                                          ),
                                                        )
                                                      ]))
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                  desktop: controller.isLoading.value
                      ? Constant.loader()
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: controller.bookingList.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 30),
                                          child: TextCustom(
                                            title: "No Orders Found".tr,
                                            fontSize: 16,
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            title: "Order History".tr,
                                            fontSize: 18,
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                          ),
                                          spaceH(),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: DataTable(
                                                horizontalMargin: 20,
                                                columnSpacing: 30,
                                                dataRowMaxHeight: 65,
                                                headingRowHeight: 65,
                                                border: TableBorder.all(
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                columns: [
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: 100),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Price".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.04),
                                                ],
                                                rows: controller.bookingList
                                                    .map((bookingModel) => DataRow(cells: [
                                                          DataCell(
                                                            TextCustom(
                                                              title: bookingModel.id!.isEmpty ? "N/A".tr : "#${bookingModel.id!.substring(0, 4)}",
                                                            ),
                                                          ),
                                                          DataCell(
                                                            SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: List.generate(
                                                                  bookingModel.items!.length,
                                                                  (index) {
                                                                    return FutureBuilder<ProductModel?>(
                                                                      future: FireStoreUtils.getProductByProductId(
                                                                        bookingModel.items![index].productId.toString(),
                                                                      ),
                                                                      builder: (context, snapshot) {
                                                                        if (!snapshot.hasData) {
                                                                          return Container();
                                                                        }
                                                                        ProductModel? product = snapshot.data ?? ProductModel();
                                                                        return Padding(
                                                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                          child: Row(
                                                                            children: [
                                                                              NetworkImageWidget(
                                                                                imageUrl: product.productImage.toString(),
                                                                                height: 24,
                                                                                width: 24,
                                                                              ),
                                                                              spaceW(width: 12),
                                                                              TextCustom(
                                                                                title: product.productName.toString(),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            TextCustom(
                                                              title: Constant.timestampToDate(bookingModel.createdAt!),
                                                            ),
                                                          ),
                                                          DataCell(
                                                            TextCustom(
                                                              title: Constant.amountShow(amount: bookingModel.totalAmount.toString()),
                                                            ),
                                                          ),
                                                          DataCell(Constant.bookingStatusText(context, bookingModel.orderStatus)),
                                                          DataCell(
                                                            InkWell(
                                                              onTap: () async {
                                                                Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${bookingModel.id}");
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_eye.svg",
                                                                color: AppThemeData.lynch400,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                          )
                                                        ]))
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),

                              // TextCustom(
                              //   title: "Order History".tr,
                              //   fontSize: 18,
                              //   fontFamily: FontFamily.regular,
                              //   color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                              // ),
                              // spaceH(),
                              // SingleChildScrollView(
                              //   scrollDirection: Axis.horizontal,
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(12),
                              //     child: DataTable(
                              //       horizontalMargin: 20,
                              //       columnSpacing: 30,
                              //       dataRowMaxHeight: 65,
                              //       headingRowHeight: 65,
                              //       border: TableBorder.all(
                              //         color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                              //         borderRadius: BorderRadius.circular(12),
                              //       ),
                              //       headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                              //       columns: [
                              //         CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: 100),
                              //         CommonUI.dataColumnWidget(context,
                              //             columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                              //         CommonUI.dataColumnWidget(context,
                              //             columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                              //         CommonUI.dataColumnWidget(context,
                              //             columnTitle: "Price".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                              //         CommonUI.dataColumnWidget(context,
                              //             columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                              //         CommonUI.dataColumnWidget(context,
                              //             columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.04),
                              //       ],
                              //       rows: controller.bookingList
                              //           .map((bookingModel) => DataRow(cells: [
                              //                 DataCell(
                              //                   TextCustom(
                              //                     title: bookingModel.id!.isEmpty ? "N/A".tr : "#${bookingModel.id!.substring(0, 4)}",
                              //                   ),
                              //                 ),
                              //                 DataCell(
                              //                   SingleChildScrollView(
                              //                     child: Column(
                              //                       crossAxisAlignment: CrossAxisAlignment.start,
                              //                       children: List.generate(
                              //                         bookingModel.items!.length,
                              //                         (index) {
                              //                           return FutureBuilder<ProductModel?>(
                              //                             future: FireStoreUtils.getProductByProductId(
                              //                               bookingModel.items![index].productId.toString(),
                              //                             ),
                              //                             builder: (context, snapshot) {
                              //                               if (!snapshot.hasData) {
                              //                                 return Container();
                              //                               }
                              //                               ProductModel? product = snapshot.data ?? ProductModel();
                              //                               return Padding(
                              //                                 padding: const EdgeInsets.symmetric(vertical: 4.0),
                              //                                 child: Row(
                              //                                   children: [
                              //                                     NetworkImageWidget(
                              //                                       imageUrl: product.productImage.toString(),
                              //                                       height: 24,
                              //                                       width: 24,
                              //                                     ),
                              //                                     spaceW(width: 12),
                              //                                     TextCustom(
                              //                                       title: product.productName.toString(),
                              //                                     ),
                              //                                   ],
                              //                                 ),
                              //                               );
                              //                             },
                              //                           );
                              //                         },
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 DataCell(
                              //                   TextCustom(
                              //                     title: Constant.timestampToDate(bookingModel.createdAt!),
                              //                   ),
                              //                 ),
                              //                 DataCell(
                              //                   TextCustom(
                              //                     title: Constant.amountShow(amount: bookingModel.totalAmount.toString()),
                              //                   ),
                              //                 ),
                              //                 DataCell(Constant.bookingStatusText(context, bookingModel.orderStatus)),
                              //                 DataCell(
                              //                   InkWell(
                              //                     onTap: () async {
                              //                       Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${bookingModel.id}");
                              //                     },
                              //                     child: SvgPicture.asset(
                              //                       "assets/icons/ic_eye.svg",
                              //                       color: AppThemeData.lynch400,
                              //                       height: 16,
                              //                       width: 16,
                              //                     ),
                              //                   ),
                              //                 )
                              //               ]))
                              //           .toList(),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        )));
        });
  }

  Padding detailsWidget(String title, String data, themeChange) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextCustom(
            title: title.tr,
            fontSize: 14,
            fontFamily: FontFamily.regular,
            color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
          ),
          TextCustom(
            title: data.tr,
            fontSize: 14,
            fontFamily: FontFamily.medium,
            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
          ),
        ],
      ),
    );
  }
}

class TopUpDialog extends StatelessWidget {
  const TopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: CustomerDetailScreenController(),
      builder: (controller) {
        return Dialog(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                        color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                      ),
                      child: TextCustom(title: "Top Up".tr, fontSize: 18),
                    ).expand(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: "Enter Top up Amount".tr,
                        title: "Top up Amount".tr,
                        controller: controller.topUpAmountController.value,
                        textInputType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      spaceH(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButtonWidget(
                            title: "Close".tr,
                            buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch400,
                            onPress: () {
                              controller.topUpAmountController.value.clear();
                              Navigator.pop(context);
                            },
                          ),
                          spaceW(),
                          CustomButtonWidget(
                            title: "Top Up".tr,
                            onPress: () {
                              if (Constant.isDemo) {
                                DialogBox.demoDialogBox();
                              } else {
                                controller.completeTopUp(DateTime.now().millisecondsSinceEpoch.toString());
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// ignore_for_file: deprecated_member_use

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
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../widget/common_ui.dart';
import '../../../components/custom_button.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/screen_size.dart';
import '../controllers/app_settings_controller.dart';

class AppSettingsView extends GetView<AppSettingsController> {
  const AppSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<AppSettingsController>(
      init: AppSettingsController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => ContainerCustom(
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
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "COUNTRY CODE".tr,
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lightGrey01 : AppThemeData.textBlack, // optional
                                      ),
                                      spaceH(height: 24),
                                      TextCustom(
                                        title: "Select your country code".tr,
                                        fontFamily: FontFamily.regular,
                                        fontSize: 14,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                      ),
                                      spaceH(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                                border: Border.all(
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                  width: 1,
                                                ),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              child: Row(
                                                children: [
                                                  CountryCodePicker(
                                                    searchStyle: TextStyle(
                                                      color: themeChange.isDarkTheme() ? Colors.white : AppThemeData.textBlack,
                                                      fontFamily: FontFamily.regular,
                                                    ),
                                                    searchDecoration: InputDecoration(
                                                      hintText: 'Search country',
                                                      hintStyle: TextStyle(
                                                        color: themeChange.isDarkTheme() ? Colors.white70 : AppThemeData.textBlack,
                                                        fontFamily: FontFamily.regular,
                                                      ),
                                                      prefixIcon: Icon(
                                                        Icons.search,
                                                        color: themeChange.isDarkTheme() ? Colors.white : AppThemeData.textBlack,
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                    showFlag: true,
                                                    showCountryOnly: false,
                                                    showOnlyCountryWhenClosed: false,
                                                    onChanged: (value) {
                                                      controller.countryCode.value = value.dialCode.toString();
                                                    },
                                                    initialSelection: controller.countryCode.value,
                                                    comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                                                    dialogSize: Size(500, 500),
                                                    dialogTextStyle: TextStyle(
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900,
                                                    ),
                                                    dialogBackgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                    flagDecoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(2)),
                                                    ),
                                                    textStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lightGrey01 : AppThemeData.textBlack,
                                                      fontFamily: FontFamily.regular,
                                                    ),
                                                    builder: (country) {
                                                      return Row(
                                                        children: [
                                                          if (country!.flagUri != null)
                                                            Image.asset(
                                                              country.flagUri!,
                                                              package: 'country_code_picker',
                                                              width: 24,
                                                              height: 16,
                                                            ),
                                                          const SizedBox(width: 8),
                                                          Text(
                                                            '${country.name} (${country.dialCode})',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lightGrey01 : AppThemeData.textBlack,
                                                              fontFamily: FontFamily.regular,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          spaceW(),
                                          Expanded(child: SizedBox())
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
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Refer & Earn".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Refer Credit".tr,
                                                hintText: "Enter referral credit amount".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    color: AppThemeData.lynch500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: controller.referralAmountController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(child: SizedBox()),
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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                              title: "Vendor Document verification".tr.toUpperCase(),
                                              fontFamily: FontFamily.bold,
                                              fontSize: 20,
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
                                                                groupValue: controller.isVendorActive.value,
                                                                onChanged: (value) {
                                                                  controller.isVendorActive.value = value ?? Status.active;
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
                                                                groupValue: controller.isVendorActive.value,
                                                                onChanged: (value) {
                                                                  controller.isVendorActive.value = value ?? Status.inactive;
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
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                              title: "Driver Document verification".tr.toUpperCase(),
                                              fontFamily: FontFamily.bold,
                                              fontSize: 20,
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
                                                                groupValue: controller.isDriverActive.value,
                                                                onChanged: (value) {
                                                                  controller.isDriverActive.value = value ?? Status.active;
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
                                                                groupValue: controller.isDriverActive.value,
                                                                onChanged: (value) {
                                                                  controller.isDriverActive.value = value ?? Status.inactive;
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
                                          ],
                                        ),
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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                              title: "Self Service".tr.toUpperCase(),
                                              fontFamily: FontFamily.bold,
                                              fontSize: 20,
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
                                                                groupValue: controller.isSelfDeliveryActive.value,
                                                                onChanged: (value) {
                                                                  controller.isSelfDeliveryActive.value = value ?? Status.active;
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
                                                                groupValue: controller.isSelfDeliveryActive.value,
                                                                onChanged: (value) {
                                                                  controller.isSelfDeliveryActive.value = value ?? Status.inactive;
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
                                          ],
                                        ),
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
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Wallet Settings".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Minimum wallet amount to deposit".tr,
                                                hintText: "Enter minimum wallet amount to deposit".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    color: AppThemeData.lynch500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: controller.minimumDepositController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Minimum wallet amount to withdraw".tr,
                                                hintText: "Enter minimum wallet amount to withdraw".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    color: AppThemeData.lynch500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: controller.minimumWithdrawalController.value),
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
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          TextCustom(
                                            title: "Delivery Charges".tr.toUpperCase(),
                                            fontFamily: FontFamily.bold,
                                            fontSize: 20,
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return CustomDialog(
                                                    title: "Delivery Charge Info".tr,
                                                    width: 500,
                                                    widgetList: [
                                                      TextCustom(
                                                        title: "• Fare per KM: This is the cost for each kilometer traveled.".tr,
                                                        color: AppThemeData.lynch300,
                                                      ),
                                                      SizedBox(height: 8),
                                                      TextCustom(
                                                        title: "• Minimum Charge: This is the minimum fare charged even if the distance is less.".tr,
                                                        color: AppThemeData.lynch300,
                                                        maxLine: 2,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      SizedBox(height: 8),
                                                      TextCustom(
                                                        title: "• Fare MinCharge With KM: Minimum fare plus per KM charges for short rides.".tr,
                                                        color: AppThemeData.lynch300,
                                                        maxLine: 2,
                                                        textAlign: TextAlign.start,
                                                      ),
                                                      SizedBox(height: 12),
                                                      TextCustom(title: "💡 Example:".tr),
                                                      SizedBox(height: 4),
                                                      TextCustom(
                                                        title: "Fare per KM: \$10".tr,
                                                        color: AppThemeData.lynch300,
                                                      ),
                                                      TextCustom(
                                                        title: "Minimum Charge: \$20".tr,
                                                        color: AppThemeData.lynch300,
                                                      ),
                                                      TextCustom(
                                                        title: "Ride Distance: 1 km → \$20 (minimum charge)".tr,
                                                        color: AppThemeData.lynch300,
                                                      ),
                                                      TextCustom(
                                                        title: "Ride Distance: 5 km → \$50 (5 x 10)".tr,
                                                        color: AppThemeData.lynch300,
                                                      ),
                                                    ],
                                                    bottomWidgetList: [],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.info, color: AppThemeData.lynch500),
                                          )
                                        ],
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Fare per KM".tr,
                                                hintText: "Enter Fare per KM".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    color: AppThemeData.lynch500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: controller.farePerKmController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Fare MinCharge With KM".tr,
                                                hintText: "Enter MinCharge With KM".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    color: AppThemeData.lynch500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: controller.minimumChargeWithinKmController.value),
                                          ),
                                        ],
                                      ),
                                      spaceH(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Fare Minimum Charge".tr,
                                                hintText: "Enter MinCharge".tr,
                                                textInputType: TextInputType.number,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    color: AppThemeData.lynch500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: controller.fareMinimumChargeController.value),
                                          ),
                                          spaceW(width: 16),
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
                                                                groupValue: controller.isDeliveryChargeActive.value,
                                                                onChanged: (value) {
                                                                  controller.isDeliveryChargeActive.value = value ?? Status.active;
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
                                                                groupValue: controller.isDeliveryChargeActive.value,
                                                                onChanged: (value) {
                                                                  controller.isDeliveryChargeActive.value = value ?? Status.inactive;
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
                                        title: "Location Radius".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                textInputType: TextInputType.name,
                                                tooltipsText: "Within Radius nearby drivers can be found.".tr,
                                                tooltipsShow: true,
                                                title: "Driver Radius".tr,
                                                hintText: "Driver Enter radius".tr,
                                                prefix: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: AppThemeData.lynch500,
                                                  ),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                controller: controller.globalRadiusController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                                textInputType: TextInputType.number,
                                                tooltipsText: "Driver Location Update".tr,
                                                tooltipsShow: true,
                                                title: "Driver Location Update".tr,
                                                hintText: "Enter location update".tr,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                prefix: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: AppThemeData.lynch500,
                                                  ),
                                                ),
                                                controller: controller.globalDriverLocationUpdateController.value),
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
                                        title: "Restaurant Location Radius".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                textInputType: TextInputType.name,
                                                tooltipsText: "Near by restaurant fide out radius".tr,
                                                tooltipsShow: true,
                                                title: "Radius".tr,
                                                hintText: "Enter radius".tr,
                                                prefix: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: AppThemeData.lynch500,
                                                  ),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                controller: controller.restaurantGlobalRadiusController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                  title: "Distance Type".tr,
                                                  fontSize: 14,
                                                ),
                                                spaceH(height: 16),
                                                Obx(
                                                  () => DropdownButtonFormField(
                                                    isExpanded: true,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.medium,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch800,
                                                    ),
                                                    dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                    hint: TextCustom(title: "Select Distance Type".tr),
                                                    onChanged: (String? distanceType) {
                                                      controller.selectedDistanceType.value = distanceType ?? "Km";
                                                    },
                                                    value: controller.selectedDistanceType.value,
                                                    items: controller.distanceType.map<DropdownMenuItem<String>>((String value) {
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
                                        title: "Order Cancellation Second".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                textInputType: TextInputType.name,
                                                tooltipsText: "Enter seconds to cancel Order when Driver not accept the Ride".tr,
                                                tooltipsShow: true,
                                                title: "Seconds".tr,
                                                hintText: "Enter second for cancel Order".tr,
                                                prefix: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/ic_clock.svg",
                                                    height: 16,
                                                    color: AppThemeData.lynch500,
                                                  ),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                controller: controller.secondsForOrderCancelController.value),
                                          ),
                                          spaceW(width: 16),
                                          const Expanded(child: SizedBox()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
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
                                            controller.saveSettingData();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Country Code".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lightGrey01 : AppThemeData.textBlack, // optional
                                      ),
                                      spaceH(height: 24),
                                      TextCustom(
                                        title: "Select your country code".tr,
                                        fontFamily: FontFamily.regular,
                                        fontSize: 14,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                      ),
                                      spaceH(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                                border: Border.all(
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                  width: 1,
                                                ),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              child: Row(
                                                children: [
                                                  CountryCodePicker(
                                                    searchStyle: TextStyle(
                                                      color: themeChange.isDarkTheme() ? Colors.white : AppThemeData.textBlack,
                                                      fontFamily: FontFamily.regular,
                                                    ),
                                                    searchDecoration: InputDecoration(
                                                      hintText: 'Search country',
                                                      hintStyle: TextStyle(
                                                        color: themeChange.isDarkTheme() ? Colors.white70 : AppThemeData.textBlack,
                                                        fontFamily: FontFamily.regular,
                                                      ),
                                                      prefixIcon: Icon(
                                                        Icons.search,
                                                        color: themeChange.isDarkTheme() ? Colors.white : AppThemeData.textBlack,
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                    showFlag: true,
                                                    showCountryOnly: false,
                                                    showOnlyCountryWhenClosed: false,
                                                    onChanged: (value) {
                                                      controller.countryCode.value = value.dialCode.toString();
                                                    },
                                                    initialSelection: controller.countryCode.value,
                                                    comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                                                    dialogSize: Size(500, 500),
                                                    dialogTextStyle: TextStyle(
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900,
                                                    ),
                                                    dialogBackgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                    flagDecoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(2)),
                                                    ),
                                                    textStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lightGrey01 : AppThemeData.textBlack,
                                                      fontFamily: FontFamily.regular,
                                                    ),
                                                    builder: (country) {
                                                      return Row(
                                                        children: [
                                                          if (country!.flagUri != null)
                                                            Image.asset(
                                                              country.flagUri!,
                                                              package: 'country_code_picker',
                                                              width: 24,
                                                              height: 16,
                                                            ),
                                                          const SizedBox(width: 8),
                                                          Text(
                                                            '${country.name} (${country.dialCode})',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lightGrey01 : AppThemeData.textBlack,
                                                              fontFamily: FontFamily.regular,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          spaceW(),
                                          Expanded(child: SizedBox())
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
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Refer & Earn".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(),
                                      CustomTextFormField(
                                          title: "Refer Credit".tr,
                                          hintText: "Enter referral credit amount".tr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          prefix: Padding(
                                            padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                            child: TextCustom(
                                              title: '${Constant.currencyModel!.symbol}',
                                              color: AppThemeData.lynch500,
                                              fontSize: 18,
                                            ),
                                          ),
                                          controller: controller.referralAmountController.value),
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
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            title: "Vendor Document verification".tr.toUpperCase(),
                                            fontFamily: FontFamily.bold,
                                            fontSize: 20,
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
                                                              groupValue: controller.isVendorActive.value,
                                                              onChanged: (value) {
                                                                controller.isVendorActive.value = value ?? Status.active;
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
                                                              groupValue: controller.isVendorActive.value,
                                                              onChanged: (value) {
                                                                controller.isVendorActive.value = value ?? Status.inactive;
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
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            title: "Driver Document verification".tr.toUpperCase(),
                                            fontFamily: FontFamily.bold,
                                            fontSize: 20,
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
                                                              groupValue: controller.isDriverActive.value,
                                                              onChanged: (value) {
                                                                controller.isDriverActive.value = value ?? Status.active;
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
                                                              groupValue: controller.isDriverActive.value,
                                                              onChanged: (value) {
                                                                controller.isDriverActive.value = value ?? Status.inactive;
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
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Wallet Settings".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                          title: "Minimum wallet amount to deposit".tr,
                                          hintText: "Enter minimum wallet amount to deposit".tr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          prefix: Padding(
                                            padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                            child: TextCustom(
                                              title: '${Constant.currencyModel!.symbol}',
                                              color: AppThemeData.lynch500,
                                              fontSize: 18,
                                            ),
                                          ),
                                          controller: controller.minimumDepositController.value),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                          title: "Minimum wallet amount to withdraw".tr,
                                          hintText: "Enter minimum wallet amount to withdraw".tr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          prefix: Padding(
                                            padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                            child: TextCustom(
                                              title: '${Constant.currencyModel!.symbol}',
                                              color: AppThemeData.lynch500,
                                              fontSize: 18,
                                            ),
                                          ),
                                          controller: controller.minimumWithdrawalController.value),
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
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Delivery Charges".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Fare per KM".tr,
                                                hintText: "Enter Fare per KM".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    color: AppThemeData.lynch500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: controller.farePerKmController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Fare MinCharge With KM".tr,
                                                hintText: "Enter MinCharge With KM".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    color: AppThemeData.lynch500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: controller.minimumChargeWithinKmController.value),
                                          ),
                                        ],
                                      ),
                                      spaceH(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Fare Minimum Charge".tr,
                                                hintText: "Enter MinCharge".tr,
                                                textInputType: TextInputType.number,
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                prefix: Padding(
                                                  padding: paddingEdgeInsets(vertical: 10, horizontal: 10),
                                                  child: TextCustom(
                                                    title: '${Constant.currencyModel!.symbol}',
                                                    color: AppThemeData.lynch500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                controller: controller.fareMinimumChargeController.value),
                                          ),
                                          spaceW(width: 16),
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
                                                                groupValue: controller.isDeliveryChargeActive.value,
                                                                onChanged: (value) {
                                                                  controller.isDeliveryChargeActive.value = value ?? Status.active;
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
                                                                groupValue: controller.isDeliveryChargeActive.value,
                                                                onChanged: (value) {
                                                                  controller.isDeliveryChargeActive.value = value ?? Status.inactive;
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
                                        title: "Location Radius".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      CustomTextFormField(
                                          textInputType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          tooltipsText: "Within Radius nearby drivers can be found.".tr,
                                          tooltipsShow: true,
                                          title: "Driver Radius".tr,
                                          hintText: "Driver Enter radius".tr,
                                          prefix: const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: AppThemeData.lynch500,
                                            ),
                                          ),
                                          controller: controller.globalRadiusController.value),
                                      spaceW(width: 16),
                                      CustomTextFormField(
                                          textInputType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          tooltipsText: "Driver location update".tr,
                                          tooltipsShow: true,
                                          title: "Driver Location Update".tr,
                                          hintText: "Enter location update".tr,
                                          prefix: const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: AppThemeData.lynch500,
                                            ),
                                          ),
                                          controller: controller.globalDriverLocationUpdateController.value),
                                      spaceW(width: 16),
                                      spaceW(width: 16),
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
                                        title: "Restaurant Location Radius".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      CustomTextFormField(
                                          textInputType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          tooltipsText: "Near by restaurant fide out radius".tr,
                                          tooltipsShow: true,
                                          title: "Radius".tr,
                                          hintText: "Enter radius".tr,
                                          prefix: const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: AppThemeData.lynch500,
                                            ),
                                          ),
                                          controller: controller.restaurantGlobalRadiusController.value),
                                      spaceW(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            title: "Distance Type".tr,
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
                                              onChanged: (String? distanceType) {
                                                controller.selectedDistanceType.value = distanceType ?? "Km";
                                              },
                                              value: controller.selectedDistanceType.value,
                                              items: controller.distanceType.map<DropdownMenuItem<String>>((String value) {
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
                                      spaceW(width: 16),
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
                                        title: "Order Cancellation Second".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      CustomTextFormField(
                                          textInputType: TextInputType.name,
                                          tooltipsText: "Enter seconds to cancel Order when Driver not accept the Ride".tr,
                                          tooltipsShow: true,
                                          title: "Seconds".tr,
                                          hintText: "Enter second for cancel Order".tr,
                                          prefix: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SvgPicture.asset(
                                              "assets/icons/ic_clock.svg",
                                              height: 16,
                                              color: AppThemeData.lynch500,
                                            ),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                          ],
                                          controller: controller.secondsForOrderCancelController.value),
                                      spaceW(width: 16),
                                    ],
                                  ),
                                ),
                                spaceH(height: 20),
                                SizedBox(
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
                                            controller.saveSettingData();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

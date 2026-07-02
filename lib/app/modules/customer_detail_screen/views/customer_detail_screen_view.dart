// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/modules/customer_detail_screen/views/other_screen/customer_address_widget.dart';
import 'package:admin_panel/app/modules/customer_detail_screen/views/other_screen/customer_orders_widget.dart';
import 'package:admin_panel/app/modules/customer_detail_screen/views/other_screen/customer_transaction_screen.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/app/utils/screen_size.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../controllers/customer_detail_screen_controller.dart';

class CustomerDetailScreenView extends GetView<CustomerDetailScreenController> {
  const CustomerDetailScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CustomerDetailScreenController>(
        init: CustomerDetailScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              leadingWidth: 200,
              // title: title,
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
                                  GradientText(
                                    TextCustom(
                                      title: '${Constant.appName}',
                                      color: AppThemeData.primary500,
                                      fontSize: 25,
                                      fontFamily: FontFamily.titleBold,
                                    ),
                                    gradient: AppThemeData.primaryGradient,
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
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: themeChange.isDarkTheme()
                        ? SvgPicture.asset(
                            "assets/icons/ic_sun.svg",
                            color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                            height: 20,
                            width: 20,
                          )
                        : SvgPicture.asset(
                            "assets/icons/ic_moon.svg",
                            color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                            height: 20,
                            width: 20,
                          ),
                  ),
                ),
                spaceW(),
                const LanguagePopUp(),
                spaceW(),
                ProfilePopUp()
              ],
            ),
            drawer: Drawer(
              // key: scaffoldKey,
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
                    child: Padding(
                        padding: paddingEdgeInsets(),
                        child: DefaultTabController(
                            length: 3,
                            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(18, 16, 16, 0),
                                decoration: BoxDecoration(
                                    color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10))),
                                child: Column(
                                  children: [
                                    ResponsiveWidget.isDesktop(context)
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                                spaceH(height: 2),
                                                Row(children: [
                                                  InkWell(
                                                      onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                      child: TextCustom(title: "Dashboard".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                  InkWell(
                                                      onTap: () => Get.offAllNamed(Routes.CUSTOMER_SCREEN),
                                                      child: TextCustom(title: "User".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                  TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                                ])
                                              ]),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                              spaceH(height: 2),
                                              Row(
                                                children: [
                                                  InkWell(
                                                      onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                      child: TextCustom(title: "Dashboard".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                  InkWell(
                                                      onTap: () => Get.offAllNamed(Routes.CUSTOMER_SCREEN),
                                                      child: TextCustom(title: "User".tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                  TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                                ],
                                              )
                                            ],
                                          ),
                                    spaceH(height: 20),
                                    controller.isLoading.value
                                        ? Constant.loader()
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ContainerCustom(
                                                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        NetworkImageWidget(
                                                          imageUrl: controller.userModel.value.profilePic.toString(),
                                                          fit: BoxFit.fill,
                                                          height: ScreenSize.height(20, context),
                                                          width: ScreenSize.width(20, context),
                                                          borderRadius: 8,
                                                        ),
                                                        spaceW(width: 16),
                                                        ContainerCustom(
                                                          padding: EdgeInsets.zero,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      TextCustom(
                                                                        title: "User Details".tr,
                                                                        fontSize: 16,
                                                                        fontFamily: FontFamily.medium,
                                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                      ),
                                                                      spaceH(height: 16),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                            "assets/icons/ic_user.svg",
                                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                          ),
                                                                          spaceW(width: 8),
                                                                          TextCustom(
                                                                            title: controller.userModel.value.fullNameString(),
                                                                            fontSize: 14,
                                                                            fontFamily: FontFamily.regular,
                                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      spaceH(height: 4),
                                                                      if (controller.userModel.value.email != null && controller.userModel.value.email!.isNotEmpty)
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              "assets/icons/ic_mail.svg",
                                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                            ),
                                                                            spaceW(width: 8),
                                                                            TextCustom(
                                                                              title: controller.userModel.value.email.toString(),
                                                                              fontSize: 14,
                                                                              fontFamily: FontFamily.regular,
                                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      spaceH(height: 4),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                            "assets/icons/ic_call.svg",
                                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                          ),
                                                                          spaceW(width: 8),
                                                                          TextCustom(
                                                                            title: "${controller.userModel.value.countryCode} ${controller.userModel.value.phoneNumber}",
                                                                            fontSize: 14,
                                                                            fontFamily: FontFamily.regular,
                                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    width: ScreenSize.width(20, context),
                                                                    height: ScreenSize.height(18, context),
                                                                    padding: const EdgeInsets.all(16),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      gradient: themeChange.isDarkTheme()
                                                                          ? const LinearGradient(
                                                                              begin: Alignment.topLeft,
                                                                              end: Alignment.bottomRight,
                                                                              colors: [
                                                                                Color(0xff7C2A12), // primary900
                                                                                Color(0xffF25812), // primary600
                                                                                Color(0xffFB9347), // primary400
                                                                              ],
                                                                            )
                                                                          : const LinearGradient(
                                                                              begin: Alignment.topLeft,
                                                                              end: Alignment.bottomRight,
                                                                              colors: [
                                                                                Color(0xffFE4E01), // secondary600
                                                                                Color(0xffFF7C64), // secondary400
                                                                                Color(0xffFFCEC5), // secondary200
                                                                              ],
                                                                            ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Wallet Amount",
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Colors.white.withOpacity(0.9),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 4),
                                                                            Obx(() {
                                                                              return Text(
                                                                                Constant.amountShow(amount: controller.userModel.value.walletAmount!),
                                                                                style: const TextStyle(
                                                                                  fontSize: 26, // bigger amount text
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              );
                                                                            }),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 40, // adjust button height
                                                                          child: CustomButtonWidget(
                                                                            title: "Top Up".tr,
                                                                            buttonColor: Colors.white,
                                                                            textColor: Colors.black,
                                                                            onPress: () {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (context) => const TopUpDialog(),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ).expand(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              spaceH(),
                                            ],
                                          )
                                  ],
                                ),
                              ),
                              spaceH(height: 16),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TabBar(
                                          indicatorColor: AppThemeData.primary500,
                                          unselectedLabelColor: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                          labelColor: AppThemeData.primary500,
                                          tabs: const [
                                            Tab(text: "Orders"),
                                            Tab(text: "Transaction"),
                                            Tab(text: "Address"),
                                          ],
                                        ),
                                        spaceH(height: 16),
                                        const SizedBox(
                                          height: 600, // required inside Column
                                          child: TabBarView(
                                            physics: NeverScrollableScrollPhysics(),
                                            children: [CustomerOrdersWidget(), CustomerTransactionScreen(), CustomerAddressWidget()],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ]))),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

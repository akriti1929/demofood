import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as osmMap;
import 'package:latlong2/latlong.dart' as osmLatLng;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_pages.dart';
import '../controllers/create_zone_controller.dart';

class CreateZoneView extends GetView<CreateZoneController> {
  const CreateZoneView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: CreateZoneController(),
      builder: (controller) {
        return ResponsiveWidget(
            mobile: Scaffold(
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
                body: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
                        child: ContainerCustom(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        ],
                      ),
                      spaceH(height: 20),
                      controller.isLoading.value
                          ? Constant.loader()
                          : Column(children: [
                              TextCustom(
                                title: "Instructions".tr,
                                fontSize: 16,
                                fontFamily: FontFamily.bold,
                              ),
                              spaceH(height: 16),
                              TextCustom(
                                title: "Allow User to define the boundary of the business zone interactively on the map by clicking to add points or dots.".tr,
                                fontSize: 14,
                                fontFamily: FontFamily.regular,
                                maxLine: 3,
                                color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                              ),
                              spaceH(height: 16),
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppThemeData.primary500,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  spaceW(width: 6),
                                  Expanded(
                                    child: TextCustom(
                                      title: "Use the 'Shape Tool' to highlight areas and connect the dots. A minimum of three points/dots required.".tr,
                                      fontSize: 14,
                                      fontFamily: FontFamily.regular,
                                      maxLine: 2,
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                    ),
                                  ),
                                ],
                              ),
                              spaceH(height: 16),
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppThemeData.primary500,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  spaceW(width: 6),
                                  TextCustom(
                                    title: "Use the 'Trash Tool' to remove the selected Area.".tr,
                                    fontSize: 14,
                                    fontFamily: FontFamily.regular,
                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                  ),
                                ],
                              ),
                              spaceH(height: 20),
                              CustomTextFormField(
                                hintText: "Enter Zone Name".tr,
                                controller: controller.zoneController.value,
                                title: "Zone Name".tr,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                                ],
                              ),
                              spaceH(height: 10),
                              const TextCustom(title: "Status"),
                              spaceH(height: 4),
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  activeTrackColor: AppThemeData.primary500,
                                  value: controller.isActive.value,
                                  onChanged: (value) {
                                    controller.isActive.value = value;
                                  },
                                ),
                              ),
                              spaceH(height: 16),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 0.7.sw,
                                      child: Stack(
                                        children: [
                                          Constant.selectedMap == "Google Map"
                                              ? GoogleMap(
                                                  onMapCreated: (GoogleMapController googleMapController) {
                                                    controller.googleMapController = googleMapController;
                                                    if (controller.polygonCoords.isNotEmpty) {
                                                      controller.moveCameraToPolygon();
                                                    }
                                                  },
                                                  initialCameraPosition: CameraPosition(
                                                    target: Constant.currentLocation != null
                                                        ? LatLng(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude)
                                                        : const LatLng(0, 0),
                                                    zoom: 13,
                                                  ),
                                                  polygons: controller.polygons.toSet(),
                                                  markers: controller.markers,
                                                  onTap: controller.addPolygon,
                                                  myLocationEnabled: true,
                                                  zoomControlsEnabled: true,
                                                  mapType: MapType.normal,
                                                )
                                              : osmMap.FlutterMap(
                                                  children: [],
                                                ),
                                          Center(child: Icon(Icons.location_pin, size: 40, color: AppThemeData.primary500)),
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            right: 10,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: controller.searchController,
                                                  style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                                    hintText: 'Search place',
                                                    border: InputBorder.none,
                                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.regular,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(50),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(50),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    disabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(50),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    if (kIsWeb) {
                                                      controller.fetchPredictions(value);
                                                    }
                                                  },
                                                ),
                                                Obx(() {
                                                  if (controller.predictions.isEmpty) return SizedBox();
                                                  return Container(
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: controller.predictions.length,
                                                      itemBuilder: (context, index) {
                                                        final p = controller.predictions[index];
                                                        return ListTile(
                                                          title: TextCustom(
                                                            title: p['description'],
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.medium,
                                                            textAlign: TextAlign.start,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900,
                                                          ),
                                                          onTap: () {
                                                            controller.selectPrediction(p);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  );
                                                })
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  spaceW(width: 12),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () => controller.addPolygon,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppThemeData.primary500,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.add_circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      spaceH(height: 16),
                                      InkWell(
                                        onTap: () => controller.clearPolygon(),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppThemeData.primary500,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              spaceH(height: 16),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CustomButtonWidget(
                                  title: "Save",
                                  buttonColor: AppThemeData.primary500,
                                  onPress: () {
                                    if (Constant.isDemo) {
                                      DialogBox.demoDialogBox();
                                    } else {
                                      if (controller.zoneController.value.text.isEmpty) {
                                        ShowToastDialog.errorToast("Please Enter Zone name..");
                                      } else {
                                        controller.addZone();
                                      }
                                    }
                                  },
                                ),
                              )
                            ])
                    ]))))),
            tablet: Scaffold(
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
                body: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
                        child: ContainerCustom(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        ],
                      ),
                      spaceH(height: 20),
                      controller.isLoading.value
                          ? Constant.loader()
                          : Column(children: [
                              TextCustom(
                                title: "Instructions".tr,
                                fontSize: 16,
                                fontFamily: FontFamily.bold,
                              ),
                              spaceH(height: 16),
                              TextCustom(
                                title: "Allow User to define the boundary of the business zone interactively on the map by clicking to add points or dots.".tr,
                                fontSize: 14,
                                fontFamily: FontFamily.regular,
                                maxLine: 3,
                                color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                              ),
                              spaceH(height: 16),
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppThemeData.primary500,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  spaceW(width: 6),
                                  Expanded(
                                    child: TextCustom(
                                      title: "Use the 'Shape Tool' to highlight areas and connect the dots. A minimum of three points/dots required.".tr,
                                      fontSize: 14,
                                      fontFamily: FontFamily.regular,
                                      maxLine: 2,
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                    ),
                                  ),
                                ],
                              ),
                              spaceH(height: 16),
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: AppThemeData.primary500,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  spaceW(width: 6),
                                  TextCustom(
                                    title: "Use the 'Trash Tool' to remove the selected Area.".tr,
                                    fontSize: 14,
                                    fontFamily: FontFamily.regular,
                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                  ),
                                ],
                              ),
                              spaceH(height: 20),
                              CustomTextFormField(
                                hintText: "Enter Zone Name".tr,
                                controller: controller.zoneController.value,
                                title: "Zone Name".tr,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                                ],
                              ),
                              spaceH(height: 10),
                              const TextCustom(title: "Status"),
                              spaceH(height: 4),
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  activeTrackColor: AppThemeData.primary500,
                                  value: controller.isActive.value,
                                  onChanged: (value) {
                                    controller.isActive.value = value;
                                  },
                                ),
                              ),
                              spaceH(height: 16),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 0.7.sw,
                                      child: Stack(
                                        children: [
                                          GoogleMap(
                                            onMapCreated: (GoogleMapController googleMapController) {
                                              controller.googleMapController = googleMapController;
                                              if (controller.polygonCoords.isNotEmpty) {
                                                controller.moveCameraToPolygon();
                                              }
                                            },
                                            initialCameraPosition: CameraPosition(
                                              target: Constant.currentLocation != null
                                                  ? LatLng(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude)
                                                  : const LatLng(0, 0),
                                              zoom: 13,
                                            ),
                                            polygons: controller.polygons.toSet(),
                                            markers: controller.markers,
                                            onTap: controller.addPolygon,
                                            myLocationEnabled: true,
                                            zoomControlsEnabled: true,
                                            mapType: MapType.normal,
                                          ),
                                          Center(child: Icon(Icons.location_pin, size: 40, color: AppThemeData.primary500)),
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            right: 10,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: controller.searchController,
                                                  style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                                    hintText: 'Search place',
                                                    border: InputBorder.none,
                                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.regular,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(50),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(50),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    disabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(50),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    if (kIsWeb) {
                                                      controller.fetchPredictions(value);
                                                    }
                                                  },
                                                ),
                                                Obx(() {
                                                  if (controller.predictions.isEmpty) return SizedBox();
                                                  return Container(
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: controller.predictions.length,
                                                      itemBuilder: (context, index) {
                                                        final p = controller.predictions[index];
                                                        return ListTile(
                                                          title: TextCustom(
                                                            title: p['description'],
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.medium,
                                                            textAlign: TextAlign.start,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900,
                                                          ),
                                                          onTap: () {
                                                            controller.selectPrediction(p);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  );
                                                })
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  spaceW(width: 12),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () => controller.addPolygon,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppThemeData.primary500,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.add_circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      spaceH(height: 16),
                                      InkWell(
                                        onTap: () => controller.clearPolygon(),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppThemeData.primary500,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              spaceH(height: 16),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CustomButtonWidget(
                                  title: "Save",
                                  buttonColor: AppThemeData.primary500,
                                  onPress: () {
                                    if (Constant.isDemo) {
                                      DialogBox.demoDialogBox();
                                    } else {
                                      if (controller.zoneController.value.text.isEmpty) {
                                        ShowToastDialog.errorToast("Please Enter Zone name..");
                                      } else {
                                        controller.addZone();
                                      }
                                    }
                                  },
                                ),
                              )
                            ])
                    ]))))),
            desktop: Scaffold(
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
                      child: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
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
                              ],
                            ),
                            spaceH(height: 20),
                            controller.isLoading.value
                                ? Constant.loader()
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                              title: "Instructions".tr,
                                              fontSize: 16,
                                              fontFamily: FontFamily.bold,
                                            ),
                                            spaceH(height: 16),
                                            TextCustom(
                                              title: "Allow User to define the boundary of the business zone interactively on the map by clicking to add points or dots.".tr,
                                              fontSize: 14,
                                              fontFamily: FontFamily.regular,
                                              textAlign: TextAlign.start,
                                              maxLine: 3,
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                            ),
                                            spaceH(height: 16),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                    color: AppThemeData.primary500,
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      Icons.add_circle,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                spaceW(width: 6),
                                                Expanded(
                                                  child: TextCustom(
                                                    title: "Use the 'Shape Tool' to highlight areas and connect the dots. A minimum of three points/dots required.".tr,
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.regular,
                                                    textAlign: TextAlign.start,
                                                    maxLine: 2,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            spaceH(height: 16),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                    color: AppThemeData.primary500,
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                spaceW(width: 6),
                                                TextCustom(
                                                  title: "Use the 'Trash Tool' to remove the selected Area.".tr,
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.regular,
                                                  textAlign: TextAlign.start,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      spaceW(width: 32),
                                      Flexible(
                                        flex: 3,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 0.25.sw,
                                                  child: CustomTextFormField(
                                                    hintText: "Enter Zone Name".tr,
                                                    controller: controller.zoneController.value,
                                                    title: "Zone Name".tr,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                                                    ],
                                                  ),
                                                ),
                                                spaceW(width: 10),
                                                Column(
                                                  children: [
                                                    TextCustom(title: "Status".tr),
                                                    spaceH(height: 4),
                                                    Transform.scale(
                                                      scale: 0.8,
                                                      child: CupertinoSwitch(
                                                        activeTrackColor: AppThemeData.primary500,
                                                        value: controller.isActive.value,
                                                        onChanged: (value) {
                                                          controller.isActive.value = value;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            spaceH(height: 12),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 0.4.sw,
                                                  height: 0.3.sw,
                                                  child: Stack(
                                                    children: [
                                                      Constant.selectedMap == "Google Map"
                                                          ? GoogleMap(
                                                              onMapCreated: (GoogleMapController googleMapController) {
                                                                controller.googleMapController = googleMapController;
                                                                if (controller.polygonCoords.isNotEmpty) {
                                                                  controller.moveCameraToPolygon();
                                                                }
                                                              },
                                                              initialCameraPosition: CameraPosition(
                                                                target: Constant.currentLocation != null
                                                                    ? LatLng(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude)
                                                                    : const LatLng(0, 0),
                                                                zoom: 13,
                                                              ),
                                                              polygons: controller.polygons.toSet(),
                                                              markers: controller.markers,
                                                              onTap: controller.addPolygon,
                                                              myLocationEnabled: true,
                                                              zoomControlsEnabled: true,
                                                              mapType: MapType.normal,
                                                            )
                                                          : osmMap.FlutterMap(
                                                              mapController: controller.osmMapController,
                                                              options: osmMap.MapOptions(
                                                                initialCenter: Constant.currentLocation != null
                                                                    ? osmLatLng.LatLng(
                                                                        Constant.currentLocation!.latitude,
                                                                        Constant.currentLocation!.longitude,
                                                                      )
                                                                    : const osmLatLng.LatLng(0, 0),
                                                                initialZoom: 13,
                                                                interactionOptions: const osmMap.InteractionOptions(
                                                                  flags: osmMap.InteractiveFlag.drag |
                                                                      osmMap.InteractiveFlag.pinchZoom |
                                                                      osmMap.InteractiveFlag.doubleTapZoom |
                                                                      osmMap.InteractiveFlag.scrollWheelZoom |
                                                                      osmMap.InteractiveFlag.flingAnimation,
                                                                ),
                                                                onTap: (tapPosition, point) {
                                                                  controller.addPolygonOSM(point);
                                                                },
                                                              ),
                                                              children: [
                                                                osmMap.TileLayer(
                                                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                                  userAgentPackageName: 'com.admin.panel',
                                                                ),
                                                                Obx(() {
                                                                  if (controller.polygonCoords.isEmpty) {
                                                                    return const SizedBox();
                                                                  }
                                                                  return osmMap.PolygonLayer(
                                                                    polygons: [
                                                                      osmMap.Polygon(
                                                                        points: controller.polygonCoords.map((e) => controller.toOsm(e)).toList(),
                                                                        borderColor: Colors.black,
                                                                        borderStrokeWidth: 3,
                                                                        color: Colors.black.withOpacity(0.2),
                                                                      ),
                                                                    ],
                                                                  );
                                                                }),
                                                                Obx(() {
                                                                  return osmMap.MarkerLayer(
                                                                    markers: controller.polygonCoords.map((point) {
                                                                      return osmMap.Marker(
                                                                        point: controller.toOsm(point),
                                                                        width: 40,
                                                                        height: 40,
                                                                        child: const Icon(
                                                                          Icons.location_on,
                                                                          color: Colors.red,
                                                                          size: 30,
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  );
                                                                }),
                                                              ],
                                                            ),
                                                      Center(child: Icon(Icons.location_pin, size: 40, color: AppThemeData.primary500)),
                                                      Positioned(
                                                        top: 10,
                                                        left: 10,
                                                        right: 10,
                                                        child: Column(
                                                          children: [
                                                            TextFormField(
                                                              controller: controller.searchController,
                                                              style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700),
                                                              decoration: InputDecoration(
                                                                filled: true,
                                                                fillColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                                                hintText: 'Search place',
                                                                border: InputBorder.none,
                                                                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                                                hintStyle: TextStyle(
                                                                    fontSize: 14,
                                                                    fontFamily: FontFamily.regular,
                                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(50),
                                                                  borderSide: BorderSide.none,
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(50),
                                                                  borderSide: BorderSide.none,
                                                                ),
                                                                disabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(50),
                                                                  borderSide: BorderSide.none,
                                                                ),
                                                              ),
                                                              onChanged: (value) {
                                                                if (kIsWeb) {
                                                                  controller.fetchPredictions(value);
                                                                }
                                                              },
                                                            ),
                                                            Obx(() {
                                                              if (controller.predictions.isEmpty) return SizedBox();
                                                              return Container(
                                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                                child: ListView.builder(
                                                                  shrinkWrap: true,
                                                                  itemCount: controller.predictions.length,
                                                                  itemBuilder: (context, index) {
                                                                    final p = controller.predictions[index];
                                                                    return ListTile(
                                                                      title: TextCustom(
                                                                        title: p['description'],
                                                                        fontSize: 16,
                                                                        fontFamily: FontFamily.medium,
                                                                        textAlign: TextAlign.start,
                                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900,
                                                                      ),
                                                                      onTap: () {
                                                                        controller.selectPrediction(p);
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            })
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                spaceW(width: 12),
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () => controller.addPolygon,
                                                      child: Container(
                                                        decoration: const BoxDecoration(
                                                          color: AppThemeData.primary500,
                                                        ),
                                                        child: const Padding(
                                                          padding: EdgeInsets.all(4.0),
                                                          child: Icon(
                                                            Icons.add_circle,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    spaceH(height: 16),
                                                    InkWell(
                                                      onTap: () => controller.clearPolygon(),
                                                      child: Container(
                                                        decoration: const BoxDecoration(
                                                          color: AppThemeData.primary500,
                                                        ),
                                                        child: const Padding(
                                                          padding: EdgeInsets.all(4.0),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            spaceH(height: 16),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                CustomButtonWidget(
                                                  title: "Save".tr,
                                                  buttonColor: AppThemeData.primary500,
                                                  onPress: () {
                                                    if (Constant.isDemo) {
                                                      DialogBox.demoDialogBox();
                                                    } else {
                                                      if (controller.zoneController.value.text.isEmpty) {
                                                        ShowToastDialog.errorToast("Please Enter Zone name..".tr);
                                                      } else {
                                                        controller.addZone();
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ));
      },
    );
  }
}

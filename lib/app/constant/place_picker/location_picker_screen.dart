import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/place_picker/location_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LocationController(),
        builder: (controller) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: TextFormField(
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
            ),
            body: controller.selectedLocation.value == null
                ? Center(child: Constant.loader())
                : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controllers) {
                    controller.mapController = controllers;
                  },
                  initialCameraPosition: CameraPosition(
                    target: controller.selectedLocation.value!,
                    zoom: 15,
                  ),
                  onCameraMove: controller.onMapMoved,
                  onCameraIdle: () {
                    if (controller.selectedLocation.value != null) {
                      controller.getAddressFromLatLng(controller.selectedLocation.value!);
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
                }),
                Center(child: Icon(Icons.location_pin, size: 40, color: Colors.red)),
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() => Text(
                          controller.address.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: FontFamily.medium, color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack),
                        )),
                        SizedBox(height: 10),
                        AppButton(
                          text: "Confirm Location".tr,
                          textColor: AppThemeData.primaryWhite,
                          onTap: controller.confirmLocation,
                          color: AppThemeData.primary500,
                          elevation: 0,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: radius(12),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

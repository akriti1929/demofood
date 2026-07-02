import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'osm_location_picker_controller.dart';

class OsmLocationPickerScreen extends StatelessWidget {
  const OsmLocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OsmLocationPickerController>(
      init: OsmLocationPickerController(),
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: TextFormField(
              controller: controller.searchController,
              onChanged: controller.searchPlace,
              style: TextStyle(
                color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                hintText: "Search place".tr,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                hintStyle: TextStyle(fontSize: 14, fontFamily: FontFamily.regular, color: AppThemeData.lightGrey05),
                prefixIcon: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
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
            ),
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: controller.selectedLocation.value ?? const LatLng(20.5937, 78.9629),
                  initialZoom: 15,
                  minZoom: 2,
                  maxZoom: 18,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  onPositionChanged: (pos, hasGesture) {
                    if (hasGesture) {
                      controller.onMapMoved(pos.center, hasGesture);
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: "com.admin.panel",
                  ),
                ],
              ),

              /// 📍 Center pin
              const Center(
                child: Icon(Icons.location_pin, size: 40, color: Colors.red),
              ),

              /// 🔍 Search results
              Obx(() {
                if (controller.suggestions.isEmpty) return const SizedBox();
                return Positioned(
                  top: 70,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.suggestions.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (_, i) {
                        final place = controller.suggestions[i];
                        return ListTile(
                          title: TextCustom(
                            title: place['display_name'],
                            fontSize: 16,
                            textAlign: TextAlign.start,
                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                          ),
                          onTap: () => controller.selectSuggestion(place),
                        );
                      },
                    ),
                  ),
                );
              }),

              /// 📦 Bottom address + confirm
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
                            style: TextStyle(fontSize: 16, fontFamily: FontFamily.medium, color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack),
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
      },
    );
  }
}

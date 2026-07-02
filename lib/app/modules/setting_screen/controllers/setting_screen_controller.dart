import 'package:admin_panel/app/modules/admin_comission_setting/views/admin_comission_setting_view.dart';
import 'package:admin_panel/app/modules/ai_setting/views/ai_setting_view.dart';
import 'package:admin_panel/app/modules/app_settings/views/app_settings_view.dart';
import 'package:admin_panel/app/modules/app_theme/views/app_theme_view.dart';
import 'package:admin_panel/app/modules/cancelling_reason/views/cancelling_reason_view.dart';
import 'package:admin_panel/app/modules/contact_us/views/contact_us_view.dart';
import 'package:admin_panel/app/modules/driver_cancelling_reason/views/driver_cancelling_reason_view.dart';
import 'package:admin_panel/app/modules/general_setting/views/general_setting_view.dart';
import 'package:admin_panel/app/modules/item_tages_screen/views/item_tags_view.dart';
import 'package:admin_panel/app/modules/landing_page/views/landing_page_view.dart';
import 'package:admin_panel/app/modules/language/views/language_view.dart';
import 'package:admin_panel/app/modules/map_setting/views/map_setting_view.dart';
import 'package:admin_panel/app/modules/platform_setting/views/platform_setting_view.dart';
import 'package:admin_panel/app/modules/smtp_settings/views/smtp_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreenController extends GetxController {
  RxString title = "Settings".obs;
  final GlobalKey<ScaffoldState> scaffoldKeysDrawer = GlobalKey<ScaffoldState>();

  Rx<SettingsItem> selectSettingWidget =
      SettingsItem(title: ["General Settings".tr], icon: "assets/icons/ic_general_setting.svg", widget: [const GeneralSettingView()], selectIndex: 0).obs;
  final settingsAllPage = [
    SettingsItem(title: ["General Settings".tr], icon: "assets/icons/ic_general_setting.svg", widget: [const GeneralSettingView()], selectIndex: 0),
    SettingsItem(title: ["App Settings".tr], icon: "assets/icons/ic_settings.svg", widget: [const AppSettingsView()], selectIndex: 0),
    SettingsItem(title: ["App Theme".tr], icon: "assets/icons/ic_theme.svg", widget: [const AppThemeView()], selectIndex: 0),
    SettingsItem(title: ["SMTP Settings".tr], icon: "assets/icons/ic_mail_open.svg", widget: [const SmtpSettingsView()], selectIndex: 0),
    SettingsItem(title: ["Map Settings".tr], icon: "assets/icons/ic_location.svg", widget: [const MapSettingView()], selectIndex: 0),
    SettingsItem(title: ["Landing Page".tr], icon: "assets/icons/ic_mail_open.svg", widget: [const LandingPageView()], selectIndex: 0),
    SettingsItem(title: ["AI Setting".tr], icon: "assets/icons/ic_ai.svg", widget: [const AiSettingView()], selectIndex: 0),
    SettingsItem(title: ["PlatFormFee Setting".tr], icon: "assets/icons/ic_fees.svg", widget: [const PlatformSettingView()], selectIndex: 0),
    SettingsItem(title: ["Admin Commission".tr], icon: "assets/icons/ic_fees.svg", widget: [const AdminCommissionSettingView()], selectIndex: 0),
    SettingsItem(title: ["Languages".tr], icon: "assets/icons/ic_earth.svg", widget: [const LanguageView()], selectIndex: 0),
    SettingsItem(title: ["Cancelling Reason".tr], icon: "assets/icons/ic_user_round.svg", widget: [const CancellingReasonView()], selectIndex: 0),
    SettingsItem(title: ["Driver Reason".tr], icon: "assets/icons/ic_user_round.svg", widget: [const DriverCancellingReasonView()], selectIndex: 0),
    SettingsItem(title: ["Item Tags".tr], icon: "assets/icons/ic_tag.svg", widget: [const ItemTagsView()], selectIndex: 0),
    // SettingsItem(title: ['About App'], icon: "assets/icons/ic_reported_user.svg", widget: [AboutAppView()], selectIndex: 0),
    // SettingsItem(title: ['Privacy Policy'], icon: "assets/icons/ic_privacy_policy.svg", widget: [PrivacyPolicyView()], selectIndex: 0),
    // SettingsItem(title: ['Terms & Condition'], icon: "assets/icons/ic_terms_&_condition.svg", widget: [TermsConditionsView()], selectIndex: 0),
    SettingsItem(title: ["Contact us".tr], icon: "assets/icons/ic_contacts.svg", widget: [const ContactUsView()], selectIndex: 0),
  ];
}

class SettingsItem {
  List<String>? title;
  String? icon;
  List<Widget>? widget;
  int? selectIndex;

  SettingsItem({this.title, this.icon, this.widget, this.selectIndex});
}

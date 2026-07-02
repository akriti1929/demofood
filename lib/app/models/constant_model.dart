// ignore_for_file: non_constant_identifier_names

class ConstantModel {
  String? jsonFileURL;
  String? notificationServerKey;
  String? minimumAmountDeposit;
  String? minimumAmountWithdraw;
  String? referralAmount;
  String? googleMapKey;
  String? selectedMap;
  String? privacyPolicy;
  String? termsAndConditions;
  String? aboutApp;
  String? customerAppColor;
  String? appName;
  String? countryCode;
  String? secondsForOrderCancel;
  String? restaurantAppColor;
  String? driverAppColor;
  bool? isVendorDocumentVerification;
  bool? isDriverDocumentVerification;
  bool? isSelfDelivery;
  bool? isDeliveryCharge;
  MapSettingModel? mapSettings;

  ConstantModel(
      {this.jsonFileURL,
      this.notificationServerKey,
      this.googleMapKey,
      this.selectedMap,
      this.privacyPolicy,
      this.termsAndConditions,
      this.minimumAmountDeposit,
      this.minimumAmountWithdraw,
      this.aboutApp,
      this.customerAppColor,
      this.appName,
      this.countryCode,
      this.secondsForOrderCancel,
      this.restaurantAppColor,
      this.driverAppColor,
      this.isVendorDocumentVerification,
      this.referralAmount,
      this.isDriverDocumentVerification,
      this.isSelfDelivery,
      this.mapSettings,
      this.isDeliveryCharge});

  ConstantModel.fromJson(Map<String, dynamic> json) {
    jsonFileURL = json['jsonFileURL'] ?? '';
    notificationServerKey = json['notification_senderId'] ?? '';
    googleMapKey = json['googleMapKey'] ?? '';
    selectedMap = json['selectedMap'] ?? '';
    privacyPolicy = json['privacyPolicy'] ?? '';
    termsAndConditions = json['termsAndConditions'] ?? '';
    minimumAmountDeposit = json['minimum_amount_deposit'] ?? "";
    referralAmount = json['referral_Amount'];
    minimumAmountWithdraw = json['minimum_amount_withdraw'] ?? "";
    aboutApp = json['aboutApp'] ?? '';
    customerAppColor = json['customerAppColor'] ?? '';
    appName = json['appName'] ?? '';
    countryCode = json['countryCode'] ?? '';
    secondsForOrderCancel = json['secondsForOrderCancel'];
    restaurantAppColor = json['restaurantAppColor'] ?? '';
    driverAppColor = json['driverAppColor'] ?? '';
    isVendorDocumentVerification = json['isVendorDocumentVerification'];
    isDriverDocumentVerification = json['isDriverDocumentVerification'];
    isSelfDelivery = json['isSelfDelivery'];
    isDeliveryCharge = json['isDeliveryCharge'];
    mapSettings = json["mapSettings"] == null ? null : MapSettingModel.fromJson(json["mapSettings"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsonFileURL'] = jsonFileURL ?? "";
    data['notification_senderId'] = notificationServerKey ?? "";
    data['googleMapKey'] = googleMapKey ?? "";
    data['selectedMap'] = selectedMap ?? "";
    data['minimum_amount_deposit'] = minimumAmountDeposit ?? "";
    data['minimum_amount_withdraw'] = minimumAmountWithdraw ?? "";
    data['privacyPolicy'] = privacyPolicy ?? "";
    data['termsAndConditions'] = termsAndConditions ?? "";
    data['aboutApp'] = aboutApp ?? "";
    data['customerAppColor'] = customerAppColor ?? "";
    data['appName'] = appName ?? "";
    data['countryCode'] = countryCode ?? "";
    data['referral_Amount'] = referralAmount ?? "";
    data['secondsForOrderCancel'] = secondsForOrderCancel ?? "60";
    data['restaurantAppColor'] = restaurantAppColor ?? "";
    data['driverAppColor'] = driverAppColor ?? "";
    data['isVendorDocumentVerification'] = isVendorDocumentVerification;
    data['isDriverDocumentVerification'] = isDriverDocumentVerification;
    data['isSelfDelivery'] = isSelfDelivery;
    data['isDeliveryCharge'] = isDeliveryCharge;
    if (mapSettings != null) {
      data['mapSettings'] = mapSettings!.toJson();
    }
    return data;
  }
}

class MapSettingModel {
  String? googleMapKey;
  String? mapType;

  MapSettingModel({this.googleMapKey, this.mapType});

  MapSettingModel.fromJson(Map<String, dynamic> json) {
    googleMapKey = json['googleMapKey'];
    mapType = json['mapType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['googleMapKey'] = googleMapKey;
    data['mapType'] = mapType;
    return data;
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/models/notification_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class SendNotification {
  static final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  // Load service account JSON
  static Future getServiceAccountJson() async {
    final response = await http.get(Uri.parse(Constant.jsonFileURL.toString()));
    return json.decode(response.body);
  }

  // Get Access Token for FCM REST API
  static Future<String> getAccessToken() async {
    final jsonData = await getServiceAccountJson();
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(jsonData);
    final client = await clientViaServiceAccount(serviceAccountCredentials, _scopes);
    return client.credentials.accessToken.data;
  }

  // Send Notification to a specific Topic
  static Future<void> sendTopicNotification({
    required String topic,
    required String title,
    required String body,
  }) async {
    final accessToken = await getAccessToken();

    final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/${Constant.notificationServerKey}/messages:send',
    );

    final message = {
      'message': {
        'topic': topic, // Example: "drivers" or "customers"
        'notification': {
          'title': title,
          'body': body,
        }
      }
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('✅ Notification sent successfully to topic: $topic');
      }
    } else {
      if (kDebugMode) {
        print('❌ Failed to send notification: ${response.body}');
      }
    }
  }

  static Future<void> sendOneNotification({
    required String token,
    required String title,
    required String body,
    required String type,
    required Map<String, dynamic> payload,
    String? orderId,
    String? ownerId,
    String? customerId,
    String? driverId,
    String? senderId,
    bool isNewOrder = false,
  }) async {
    // Save notification in Firestore
    NotificationModel notificationModel = NotificationModel();

      notificationModel.id = Constant.getUuid();
      notificationModel.type = type;
      notificationModel.title = title;
      notificationModel.description = body;
      notificationModel.orderId = orderId;
      notificationModel.customerId = customerId;
      notificationModel.ownerId = ownerId;
      notificationModel.driverId = driverId;
      notificationModel.senderId = senderId;
      notificationModel.createdAt = Timestamp.now();
      await FireStoreUtils.setNotification(notificationModel);


    final String accessToken = await getAccessToken();

    log("_____________________________________________________________________");
    log("token--->$token");
    log("AccessToken--->$accessToken");
    log("_____________________________________________________________________");

    Map<String, dynamic> mergedPayload = {
      ...orderId != null ? notificationModel.toNotificationJson() : payload,
      'isNewOrder': isNewOrder ? 'true' : 'false',
    };

    // Fixed message payload
    Map<String, dynamic> message = {
      'token': token,
      'data': mergedPayload, // always include data for background handling
      'android': {
        'notification': {
          'channel_id': isNewOrder ? 'orders_channel' : 'default_channel',
          'title': title,
          'body': body,
          'sound': isNewOrder ? 'order_sound' : 'default',
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
      },
      'apns': {
        'headers': {'apns-priority': '10'},
        'payload': {
          'aps': {
            'alert': {'title': title, 'body': body}, // required for display
            'sound': isNewOrder ? 'order_sound.wav' : 'default', // must exist in iOS bundle
            'content-available': 1,
          },
        },
      },
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/${Constant.notificationServerKey}/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'message': message}),
      );

      log("✅ Notification sent: ${response.body}");
    } catch (e) {
      log("❌ Error sending notification: $e");
    }
  }
}

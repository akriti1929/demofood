// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/models/email_template_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailTemplateController extends GetxController {
  RxBool isLoading = false.obs;

  RxString title = "Email Templates".tr.obs;
  RxString initialBody = ''.obs;
  Rx<HtmlEditorController> htmlEditorController = HtmlEditorController().obs;
  Rx<TextEditingController> subjectController = TextEditingController().obs;

  RxList<EmailTemplateModel> emailTemplatesList = <EmailTemplateModel>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    emailTemplatesList.clear();
    try {
      List<EmailTemplateModel> data = await FireStoreUtils.getEmailTemplate();

      if (data.isNotEmpty) {
        emailTemplatesList.addAll(data);
      } else {
        await addDefaultTemplate();
        emailTemplatesList.addAll(_defaultTemplates);
      }
    } catch (e) {
      log("❌ Error in get Email template : $e");
      // If Firestore fails, still show default list
      emailTemplatesList.addAll(_defaultTemplates);
    } finally {
      isLoading.value = false;
    }
  }

  List<EmailTemplateModel> get _defaultTemplates => [
        EmailTemplateModel(
          id: 'signup',
          type: 'signup',
          subject: 'Welcome to {{app_name}}, {{name}}!',
          status: true,
          body: '''
      <div style="font-family: 'Satoshi', Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 24px; color: #333; line-height: 1.6;">
        <div style="max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); overflow: hidden; padding: 24px;">
          <h2 style="text-align:center;">Welcome to {{app_name}} 🎉</h2>
          <p>Hi <strong>{{name}}</strong>,</p>
          <p>Thanks for joining the fastest food delivery service in town. Get ready to explore top restaurants and delicious cuisines near you.</p>
          <p>We’re thrilled to have you on board!</p>
          <hr style="margin:24px 0; border:none; border-top:1px solid #eee;">
          <p style="text-align:center; font-size:13px;">© {{app_name}} | Eat Fresh. Eat Fast.</p>
        </div>
      </div>
    ''',
        ),
        EmailTemplateModel(
          id: 'wallet_topup',
          type: 'wallet_topup',
          subject: 'Wallet Top-Up Successful!',
          status: true,
          body: '''
      <div style="font-family: 'Satoshi', Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 24px; color: #333; line-height: 1.6;">
        <div style="max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); overflow: hidden; padding: 24px;">
          <h2 style="text-align:center;">Wallet Top-Up Successful 💰</h2>
          <p>Hi <strong>{{name}}</strong>,</p>
          <p>Your wallet has been topped up with <strong>{{amount}}</strong>.</p>
          <p><strong>Current Balance:</strong> {{balance}}</p>
          <p>You can now enjoy faster checkouts with your wallet balance!</p>
          <hr style="margin:24px 0; border:none; border-top:1px solid #eee;">
          <p style="text-align:center; font-size:13px;">© {{app_name}} | Your wallet, your power.</p>
        </div>
      </div>
    ''',
        ),
        EmailTemplateModel(
          id: 'order_delivered',
          type: 'order_delivered',
          subject: 'Delivered! Enjoy Your Meal, {{name}}!',
          status: true,
          body: '''
      <div style="font-family: 'Satoshi', Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 24px; color: #333; line-height: 1.6;">
        <div style="max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); overflow: hidden; padding: 24px;">
          <h2 style="text-align:center;">Order Delivered 🚚</h2>
          <p>Hi <strong>{{name}}</strong>,</p>
          <p>Your order <strong>#{{order_id}}</strong> has been successfully delivered!</p>
          <p>We hope you enjoy your meal from <strong>{{restaurant_name}}</strong> 🍽️.</p>
          <h3>Order Summary:</h3>
          <ul>
            <li><strong>Total Amount:</strong> {{total_amount}}</li>
            <li><strong>Delivery Address:</strong> {{delivery_address}}</li>
          </ul>
          <p>Thank you for choosing <strong>{{app_name}}</strong>. We look forward to serving you again soon!</p>
          <hr style="margin:24px 0; border:none; border-top:1px solid #eee;">
          <p style="text-align:center; font-size:13px;">© {{app_name}} | Deliciousness delivered.</p>
        </div>
      </div>
    ''',
        ),
        EmailTemplateModel(
          id: 'withdraw_request',
          type: 'withdraw_request',
          subject: 'Withdrawal Request Received',
          status: true,
          body: '''
      <div style="font-family: 'Satoshi', Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 24px; color: #333; line-height: 1.6;">
        <div style="max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); overflow: hidden; padding: 24px;">
          <h2 style="text-align:center;">Withdrawal Request Received 💸</h2>
          <p>Hi <strong>{{name}}</strong>,</p>
          <p>Your withdrawal request of <strong>{{amount}}</strong> has been received.</p>
          <p>We are processing your request and will notify you once the transfer is complete.</p>
          <hr style="margin:24px 0; border:none; border-top:1px solid #eee;">
          <p style="text-align:center; font-size:13px;">© {{app_name}} | We value your trust.</p>
        </div>
      </div>
    ''',
        ),
        EmailTemplateModel(
          id: 'withdraw_request_admin',
          type: 'withdraw_request_admin',
          subject: 'New Withdrawal Request Received from {{name}}',
          status: true,
          body: '''
  <div style="font-family: 'Satoshi', Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 24px; color: #333; line-height: 1.6;">    
  <div style="max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); overflow: hidden; padding: 24px;">      
  <h2 style="text-align:center;">New Withdrawal Request 💼</h2>      <p>Hello <strong>Admin</strong>,</p>      
  <p>The {{user_type}}&nbsp;<strong>{{name}}</strong> has submitted a new withdrawal request.</p>      
  <p><strong>Requested Amount:</strong> {{amount}}</p>      
  <p><strong>Name:</strong> {{user_name}}</p>      
  <p><strong>Date &amp; Time:</strong> {{request_date}}</p>      
  <p>Please review and process this withdrawal request in the admin panel.</p>      
  <hr style="margin:24px 0; border:none; border-top:1px solid #eee;">     
   <p style="text-align:center; font-size:13px;">© {{app_name}} | Admin Notification</p>    
   </div>  
   </div>
  ''',
        ),
        EmailTemplateModel(
          id: 'withdraw_complete',
          type: 'withdraw_complete',
          subject: 'Withdrawal Completed',
          status: true,
          body: '''
      <div style="font-family: 'Satoshi', Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 24px; color: #333; line-height: 1.6;">
        <div style="max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); overflow: hidden; padding: 24px;">
          <h2 style="text-align:center;">Withdrawal Completed ✅</h2>
          <p>Hi <strong>{{name}}</strong>,</p>
          <p>Your withdrawal of <strong>{{amount}}</strong> has been successfully processed and transferred to your linked account.</p>
          <hr style="margin:24px 0; border:none; border-top:1px solid #eee;">
          <p style="text-align:center; font-size:13px;">© {{app_name}} | Fast, secure, and reliable.</p>
        </div>
      </div>
    ''',
        ),
        EmailTemplateModel(
          id: 'refer_and_earn',
          type: 'refer_and_earn',
          subject: 'You Earned Rewards!',
          status: true,
          body: '''
      <div style="font-family: 'Satoshi', Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 24px; color: #333; line-height: 1.6;">
        <div style="max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); overflow: hidden; padding: 24px;">
          <h2 style="text-align:center;">You Earned Rewards 🎁</h2>
          <p>Hi <strong>{{name}}</strong>,</p>
          <p>Congratulations! You referred <strong>{{referral_name}}</strong> and earned <strong>{{amount}}</strong> in rewards!</p>
          <p>Keep sharing the love — the more you refer, the more you earn.</p>
          <hr style="margin:24px 0; border:none; border-top:1px solid #eee;">
          <p style="text-align:center; font-size:13px;">© {{app_name}} | Sharing is rewarding.</p>
        </div>
      </div>
    ''',
        ),
        EmailTemplateModel(
          id: 'order_confirmed',
          type: 'order_confirmed',
          subject: 'Order Confirmed! Your Feast #{{order_id}} is Being Prepared.',
          status: true,
          body: '''
      <div style="font-family: Arial, sans-serif; color: #333; background:#f9f9f9; padding:20px;">
   <div style="max-width:700px; margin:auto; background:#fff; border-radius:10px; padding:25px; box-shadow:0 2px 10px rgba(0,0,0,0.05);">
      <h2 style="color:#4CAF50; text-align:center;">Order Confirmation</h2>
      <p>Hi <b>{{name}}</b>,</p>
      <p>Your order <b>#{{order_id}}</b> from <b>{{restaurant_name}}</b> has been received successfully.</p>

      <h3 style="color:#4CAF50;">🛍️ Order Items</h3>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse; margin-top: 10px;">
          <thead>
              <tr style="background-color: #f2f2f2;">
                  <th align="left" style="padding: 10px; border-bottom: 2px solid #ddd; color: #333;">Item</th>
                  <th align="center" style="padding: 10px; border-bottom: 2px solid #ddd; color: #333; width: 80px;">Qty</th>
                  <th align="right" style="padding: 10px; border-bottom: 2px solid #ddd; color: #333; width: 100px;">Price</th>
              </tr>
          </thead>
          <tbody>
              {{items}}
          </tbody>
      </table>

      <br>

      <h3 style="color:#4CAF50;">📊 Order Summary</h3>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
          <tbody>
              <tr>
                  <td align="right" style="padding: 8px 0; width: 70%; border-bottom: 1px solid #eee;"><b>Subtotal:</b></td>
                  <td align="right" style="padding: 8px 0; width: 30%; border-bottom: 1px solid #eee;">₹{{sub_total}}</td>
              </tr>
              <tr>
                  <td align="right" style="padding: 8px 0; border-bottom: 1px solid #eee;"><b>Discount:</b></td>
                  <td align="right" style="padding: 8px 0; border-bottom: 1px solid #eee;">₹{{discount}}</td>
              </tr>

              {{tax_list}}

              <tr>
                  <td align="right" style="padding: 8px 0; border-bottom: 1px solid #eee;"><b>Delivery Charge:</b></td>
                  <td align="right" style="padding: 8px 0; border-bottom: 1px solid #eee;">₹{{delivery_charge}}</td>
              </tr>
              
              <tr style="background-color: #e6ffe6;">
                  <td align="right" style="padding: 10px 0; font-size:18px; color:#4CAF50; font-weight:bold; border-top: 2px solid #4CAF50;">Total:</td>
                  <td align="right" style="padding: 10px 0; font-size:18px; color:#4CAF50; font-weight:bold; border-top: 2px solid #4CAF50;">₹{{total_amount}}</td>
              </tr>
          </tbody>
      </table>

      <hr style="margin:25px 0;">

      <h3 style="color:#4CAF50;">🚚 Delivery Details</h3>
      <p><b>Type:</b> {{delivery_type}}</p>
      <p><b>Address:</b> {{delivery_address}}</p>
      <p><b>Instructions:</b> {{delivery_instruction}}</p>

      <h3 style="color:#4CAF50;">💳 Payment Info</h3>
      <p><b>Payment Type:</b> {{payment_type}}</p>
      <p><b>Status:</b> {{payment_status}}</p>
      <p><b>Transaction ID:</b> {{transaction_id}}</p>

      <h3 style="color:#4CAF50;">📅 Order Info</h3>
      <p><b>Date:</b> {{order_date}}</p>
      <p><b>Status:</b> {{order_status}}</p>
      <p style="text-align:center; margin-top:30px;">Thank you for ordering from <b>{{app_name}}</b>! 🍴</p>
   </div>
</div>
    ''',
        ),
        EmailTemplateModel(
          id: 'restaurant_added',
          type: 'restaurant_added',
          subject: 'Your Restaurant "{{restaurant_name}}" Has Been Added Successfully!',
          status: true,
          body: '''
  <div style="font-family: 'Satoshi', Arial, sans-serif; background-color: #f5f7fa; padding: 40px; color: #333;">
    <div style="max-width: 600px; background-color: #ffffff; margin: 0 auto; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); padding: 30px;">
      
      <div style="text-align: center; margin-bottom: 25px;">
        <h2 style="color: #222; font-size: 22px; margin: 0;">🎉 Congratulations, {{name}}!</h2>
      </div>

      <p style="font-size: 16px; line-height: 1.6; margin: 0 0 15px;">
        Your restaurant <strong>{{restaurant_name}}</strong> has been successfully added to <strong>{{app_name}}</strong>.
      </p>

      <p style="font-size: 16px; line-height: 1.6; margin: 0 0 15px;">
        Our team will review your details and verify your restaurant shortly. Once approved, customers will be able to discover and place orders from your restaurant through our platform.
      </p>

      <div style="background-color: #f9fafc; border-radius: 10px; padding: 15px; margin: 20px 0;">
        <p style="margin: 0; font-size: 15px;">
          📍 <strong>Restaurant Address:</strong> {{restaurant_address}}<br>
          ☎️ <strong>Contact Number:</strong> {{restaurant_phone}}<br>
          🕒 <strong>Opening Hours:</strong> {{opening_hours}}
        </p>
      </div>

      <p style="font-size: 16px; margin: 20px 0 10px;">
        You can manage your restaurant, add menus, update timings, and track orders directly from your <strong>{{app_name}}</strong> dashboard.
      </p>

      <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;"/>

      <p style="text-align: center; font-size: 14px; color: #666;">
        Thank you for partnering with <strong>{{app_name}}</strong>!<br>
        We’re excited to have your restaurant on board.
      </p>

    </div>
  </div>
  ''',
        ),
      ];

  Future<void> addDefaultTemplate() async {
    try {
      for (var template in _defaultTemplates) {
        await FirebaseFirestore.instance.collection(CollectionName.emailTemplate).doc(template.id).set(template.toJson());
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving default templates: $e');
      }
    }
  }
}

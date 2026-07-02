import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

import 'app/routes/app_pages.dart';

import 'package:admin_panel/app/constant/constants.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Use a synchronous check for login status (Mock Mode)
    // bool isLoggedIn = FirebaseAuth.instance.currentUser == null?false:true;
    bool isLoggedIn = Constant.isLogin;
    
    if (!isLoggedIn && route != Routes.LOGIN_PAGE) {
      return const RouteSettings(name: Routes.LOGIN_PAGE);
    }
    return null;
  }
}

import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';

class LoginRepo extends ApiRepo {
  sendOtp(String email) async => await client.auth.signInWithOtp(email: email);
  Future<void> verifyOtp(String otp, String email) async {
    try {
      await client.auth.verifyOTP(
        type: OtpType.email,
        token: otp,
        email: email,
      );
      await ctx!.read<CommonViewModel>().init();
      NavigationHelper.go(RouteNames.home);
    } catch (e) {
      log(e.toString());
    }
  }
}

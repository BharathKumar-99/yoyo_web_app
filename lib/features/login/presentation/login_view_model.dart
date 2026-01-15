import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/login/data/login_repo.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  bool sentOtp = false;
  bool isButtonDisabled = false;
  int countdown = 0;
  bool isLoading = false;

  Timer? _timer;
  final LoginRepo _repo = LoginRepo();

  Future<void> sendOtp(BuildContext context) async {
    if (isButtonDisabled) return;

    sentOtp = true;
    isButtonDisabled = true;
    countdown = 60;
    notifyListeners();

    await _repo.sendOtp(emailController.text.trim());

    _startCountdown(context);
  }

  void _startCountdown(BuildContext context) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        if (context.mounted) {
          notifyListeners();
        }
      } else {
        isButtonDisabled = false;
        timer.cancel();
        if (context.mounted) {
          notifyListeners();
        }
      }
    });
  }

  Future<void> verifyOtp() async {
    isLoading = true;
    notifyListeners();
    await _repo.verifyOtp(
      pinCodeController.text.trim(),
      emailController.text.trim(),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/login/data/login_repo.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  bool sentOtp = false;
  bool isButtonDisabled = false;
  int countdown = 0;

  Timer? _timer;
  final LoginRepo _repo = LoginRepo();

  Future<void> sendOtp() async {
    if (isButtonDisabled) return;

    sentOtp = true;
    isButtonDisabled = true;
    countdown = 60;
    notifyListeners();

    await _repo.sendOtp(emailController.text.trim());

    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        notifyListeners();
      } else {
        isButtonDisabled = false;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  Future<void> verifyOtp() async {
    await _repo.verifyOtp(
      pinCodeController.text.trim(),
      emailController.text.trim(),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    emailController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }
}

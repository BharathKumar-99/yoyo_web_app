import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/login/presentation/login_constants.dart';
import 'package:yoyo_web_app/features/login/presentation/login_view_model.dart';

import '../../../../config/constants/constants.dart';
import '../../../../config/theme/app_text_styles.dart';

class LoginWidgets {
  static Container bgWidget(Widget child) => Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(gradient: LoginConstants.bgGradiant),
    child: Center(child: child),
  );

  static SizedBox loginCard(double height, width, Widget child) => SizedBox(
    height: height,
    width: width,
    child: Card(child: child),
  );

  static otpField(BuildContext context, LoginViewModel vm,double padding) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: padding
    ),
    child: PinCodeTextField(
      controller: vm.pinCodeController,
      appContext: context,
      length: 6,
      onAutoFillDisposeAction: AutofillContextAction.commit,
      onCompleted: (value) => vm.verifyOtp(),
      keyboardType: TextInputType.number,
      autoFocus: true,
      textStyle: TextStyle(fontWeight: FontWeight.w400),
      cursorColor: Colors.grey,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        activeBorderWidth: 1.5,
        inactiveBorderWidth: 1.5,
        selectedBorderWidth: 1.5,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.grey[400],
        activeColor: Color(0xFF6155F5),
        inactiveColor: Colors.grey[400],
        selectedColor: Colors.white,
      ),
    ),
  );

  static emailTextField(LoginViewModel vm) => TextField(
    controller: vm.emailController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Email Address",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Image.asset(IconConstants.emailIcon),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static sendOtpBtn(LoginViewModel vm) => ElevatedButton(
    onPressed: vm.isButtonDisabled ? null : vm.sendOtp,
    child: vm.isButtonDisabled
        ? Text("Resend in ${vm.countdown}s")
        : const Text("Send OTP"),
  );
  static verifyOtpBtn(LoginViewModel vm) => ElevatedButton(
    onPressed: () => vm.verifyOtp(),
    child: Text('Verify OTP'),
  );
}

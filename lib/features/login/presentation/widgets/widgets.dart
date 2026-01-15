import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/login/presentation/login_constants.dart';
import 'package:yoyo_web_app/features/login/presentation/login_view_model.dart';
import 'package:yoyo_web_app/features/login/presentation/widgets/loader.dart';

import '../../../../config/constants/constants.dart';
import '../../../../config/theme/app_text_styles.dart';

class LoginWidgets {
  static Container bgWidget(Widget child, LoginViewModel viewModel) =>
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: LoginConstants.bgGradiant),
        child: viewModel.isLoading ? WebStyleLoader() : Center(child: child),
      );

  static loginCard(double height, width, Widget child) => child;

  static otpField(BuildContext context, LoginViewModel vm, double padding) =>
      SizedBox(
        width: 400,
        child: PinCodeTextField(
          controller: vm.pinCodeController,
          appContext: context,
          length: 6,
          onAutoFillDisposeAction: AutofillContextAction.commit,
          onCompleted: (value) => vm.verifyOtp(),
          keyboardType: TextInputType.number,
          autoFocus: true,
          textStyle: TextStyle(fontWeight: FontWeight.w400),
          cursorColor: Colors.white,
          animationType: AnimationType.fade,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            activeBorderWidth: 1.5,
            inactiveBorderWidth: 1.5,
            selectedBorderWidth: 1.5,
            activeFillColor: Colors.transparent,
            inactiveFillColor: Colors.transparent,
            selectedFillColor: Colors.transparent,
            activeColor: Color(0xFF6155F5),
            inactiveColor: Colors.grey[400],
            selectedColor: Colors.white,
          ),
        ),
      );

  static emailTextField(LoginViewModel vm, BuildContext context) => SizedBox(
    width: 400,
    child: TextField(
      controller: vm.emailController,
      style: AppTextStyles.textTheme.bodySmall!.copyWith(color: Colors.white),
      onSubmitted: (value) => vm.sendOtp(context),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16),
        hintText: "Email Address",
        hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
          color: Colors.white,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Image.asset(IconConstants.emailIcon, color: Colors.white),
        ),
        prefixIconConstraints: const BoxConstraints(
          maxHeight: 40,
          maxWidth: 40,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
  );

  static sendOtpBtn(LoginViewModel vm, BuildContext context) => SizedBox(
    width: 400,
    child: ElevatedButton(
      onPressed: () => vm.isButtonDisabled ? null : vm.sendOtp(context),
      child: vm.isButtonDisabled
          ? Text(
              "Resend in ${vm.countdown}s",
              style: TextStyle(color: Colors.white),
            )
          : const Text("Send OTP"),
    ),
  );
  static verifyOtpBtn(LoginViewModel vm) => SizedBox(
    width: 400,
    child: ElevatedButton(
      onPressed: () => vm.verifyOtp(),
      child: Text('Verify OTP'),
    ),
  );
}
